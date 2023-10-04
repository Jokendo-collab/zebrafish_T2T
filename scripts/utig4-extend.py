#!/usr/bin/env python3


import sys
import re
import shutil
import os
import networkx as nx
#import graph_functions

#improve (rDNA) with ONT alignments.

#assuming that last edge in the path is unique
rukki_file = sys.argv[1]
ont_aligns = sys.argv[2]
graph = sys.argv[3]
'''
cutoff = int(sys.argv[4])
#edges with this and higher coverage are considered repeats
#can be automatized but do not want

avgcov = float(sys.argv[5])
#S       utig4-0 *       LN:i:131601635  RC:i:8039543882 ll:f:61.1
manual = sys.argv[6]
manual_repeat = set()
manual_unique = set()

#chromosomes to ignore
forbidden = set()
for line in open (manual):
    arr = line.strip().split()
    if arr[0] == "unique":
        for i in range (1, len(arr)):
            manual_unique.add(arr[i])
    elif arr[0] == "repeat":
        for i in range (1, len(arr)):
            manual_repeat.add(arr[i])
    elif arr[0] == "forbidden":
        for i in range (1, len(arr)):
            forbidden.add(arr[i])
    else:
        print("corrupted manual file")
        exit()
'''    
nodelens = {}
nodecov = {}
link_len = {}
for line in open (graph):
    arr = line.split()
    if arr[0] == "S":
        node = arr[1]
        lens = int(arr[3].split(':')[2])
        for pref in {'>', '<'}:
            nodelens[pref + node] = lens
            if len(arr) > 5:
                nodecov[pref + node] = float(arr[5].split(':')[2])
            else:
                nodecov[pref + node] = 0
#L       utig4-984       +       utig4-1202      +       2929M           
    if arr[0] == "L":
        if arr[2] == "+":
            f1 = ">" + arr[1]
            b2 = "<" + arr[1]
        else:
            f1 = "<" + arr[1]
            b2 = ">" + arr[1]

        if arr[4] == "+":
            b1 = ">" + arr[3]
            f2 = "<" + arr[3]
        else:
            b1 = "<" + arr[3]
            f2 = ">" + arr[3]
        if not f1 in link_len:
            link_len[f1] = {}
        if not f2 in link_len:
            link_len[f2] = {}
        if arr[1] == "utig1-32321":
            print (f1+b1+" " +f2+b2)
        llen = 0
        if arr[4][:-1].isdigit():
            llen = int(arr[4][:-1])

        link_len[f1][b1] = llen
        link_len[f2][b2] = llen



def parse_path(rukki_path):
    global weights_map
    res = 0
    separators = ">|<|\[|\]|,"
    pattern = r'(<utig4-\d+)|(>utig4-\d+)|([.*])'
    edges = re.split(pattern, rukki_path)
    edges = list(filter(None, edges))
    return edges

def parse_path_tsv(rukki_path):
    global weights_map
    res = 0
    separators = ">|<|\[|\]|,"
    pattern = r'(utig4-\d+)|(utig4-\d-)|([.*])'
#    edges = re.split(pattern, rukki_path)
#    edges = list(filter(None, edges))
    edges = rukki_path.split(',')
    new_edges = []
    for edge in edges:
        new_edge = edge[:-1]
        if edge[-1] == "+":
            new_edge = ">" + new_edge
        else:
            new_edge = "<" + new_edge
        new_edges.append(new_edge)
    print (new_edges)
    return new_edges



reads = []
for line in open (ont_aligns):
    seq = line.strip().split('\t')[5]
    
    arr = parse_path(seq)
    if len(arr) > 1:
        reads.append(seq)    
#        reads.append(arr.copy())    

        arr.reverse()
        for i in range (0, len(arr)):
            if arr[i][0] == '>':            
                arr[i] = '<' + arr[i][1:]
            elif arr[i][0] == '<':
                arr[i] = '>' + arr[i][1:]
        reads.append("".join(arr))
        
#    reads.append(arr.copy())    
sys.stderr.write("Parsed input\n")
directions = [1] #before and after gap
for line in open (rukki_file):
    arr = line.split()
    nodes = parse_path(arr[1])
    
    pos = len(nodes) -1
    print ()
    active_reads = reads.copy()
    to_search = ""
    active_node_list = [nodes[pos]]
    to_search = nodes[pos]                            

    reuse = len(active_node_list)
    progress = True
    shift_to_uniq = 0

    
    while True:
        if not (progress):
            continue
        progress = False
        print (f"searching... {to_search}")
        active = ""
        for nd in active_node_list:
            active += f"{nd}:{nodelens[nd]}:{nodecov[nd]}  " 
        print (active)
        useful_reads = []
        str_reads = [] 
        for read in reads:
            if read.find(to_search)!= -1:
                align = read
                uuu = parse_path(align)
                str_reads.append(read)
                if len(uuu) > len(active_node_list): #otherwise no sence
                    useful_reads.append(uuu) 
        print (f"useful {len(useful_reads)}")        
        extensions = {}
        stopped = 0
#                    for useful_read in useful_reads:#useful_reads:                    
        for useful_read in useful_reads:#useful_reads:                    
#                       useful_read = parse_path(useful_read_str)
            for ii in range (0, len(useful_read)):
                found = True
                for k in range (shift_to_uniq, len(active_node_list)):
                    if (ii + k >= len(useful_read) + shift_to_uniq or active_node_list[k] != useful_read[ii + k - shift_to_uniq]):
                        found = False
                        break
                if found:
                    next_pos = ii + len(active_node_list)
                    if next_pos < 0  or next_pos >= len(useful_read):
                        stopped += 1
                    else:
                        if not (useful_read[next_pos] in extensions.keys()):
                            extensions[useful_read[next_pos]] = 0
                        extensions[useful_read[next_pos]] += 1
                    break

        print ("making desicion...")
        sum_ext = 0
        max_ext = ""
        for extension in extensions:
            sum_ext += extensions[extension]
            if max_ext == "" or extensions[extension] > extensions[max_ext]:
                max_ext = extension
        if max_ext != "":
            print (f"extension search stopped {stopped} best {extensions[max_ext]} total {sum_ext}")
        else:
            print ("no extension found")
        if max_ext != "" and extensions[max_ext] * 1.6 >= sum_ext and extensions[max_ext] > 3:
            print ("going further")
            progress = True            
            to_search = to_search + max_ext
            active_node_list = active_node_list + [max_ext]
            '''if max_ext[1:] in manual_unique:
                shift_to_uniq = len (active_node_list) -1
                print (f"Shifting to {shift_to_uniq}")
                to_search = max_ext'''
        else:
            print ("stopped")
            if max_ext != "" and extensions[max_ext] * 1.6 < sum_ext and extensions[max_ext] > 5:
                print ("WARN, non-unique continuation")
                print(extensions)
            print ("".join(to_search))
            break

    res_nodes = []
    res_nodes.extend(nodes)
    res_nodes.extend(active_node_list[1:])
    adlen = 0
    for j in range (len(nodes), len(res_nodes)):
        adlen += nodelens[res_nodes[j]]
        print (res_nodes[j - 1]+ " " + res_nodes[j])
        adlen -= link_len[res_nodes[j - 1]][res_nodes[j]]                    
        new_seq = "".join(res_nodes)
    print("\t".join([arr[0], new_seq, "path_extended"]))
    print (f"Added compressed length {adlen}")
    sys.stdout.flush()
                            
                    
