#!/usr/bin/python3
# PCAD Netlist converter to Verilog pattern
# Copyright (c) 2019 1801BM1 <1801bm1@gmail.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 3
# as published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

import argparse
import collections
import itertools
import copy
import sys
import re

netlist = {}
cmplist = {}

class tcmp(object):
    def __init__(self):
        self.pins = {}
        self.attr = {}
        self.name = ""
    
class tnet(object):
    def __init__(self):
        self.nodes = {}
        self.name = ""

class netlist_state(object):
    STATE_IDLE = 0
    STATE_NETLIST = 1
    STATE_COMP = 2
    STATE_NET = 3
    STATE_NODE = 4
    def __init__(self):
        self.s = self.STATE_IDLE

valid_token = ["(", ")",
               "asciiHeader",
               "netlist",
               "compInst",
               "compRef",
               "originalName",
               "compValue",
               "patternName",
               "net",
               "node",
               "ACCEL_ASCII"]

valid_comp  = ["compRef",
               "originalName",
               "compValue",
               "patternName"]

def sxerr(code, nline, token):
    print("Syntax error [%d] in line %d \"%s\"" % (code, nline, token))
    exit(-1)

#
# Load netlist from file in PCAD 2004 ASCII netlist format
#
def read_netlist(f, verb):
    state = netlist_state()
    nline = 0		# number of line
    ignor = 0		# amount of tokens to skip
    ncomp = 0		# amount of components processed
    nnet  = 0		# amount of nets processed
    nskip = 0		# parenthesses level to skip
    token  = ""         # current token
    comp = tcmp()       # current component
    cnet = tnet()	# current component
    pins = []           # node pin list

    print("Loading netlist file: %s" % f.name)
    for line in f:
        line = line.strip()
        nline += 1
        for mt in re.finditer(r"(\".+?\")|(\()|(\))|([^\s\n\)\(\"]+)", line):
            prev = token
            token = mt.group()
#
# Ignore all tokens in skip mode till level closure
#
            if nskip:
                if token == ")":
                    nskip -= 1
                    continue
                if token == "(":
                    nskip += 1
                continue
#
# Check whether token is supported
#
            if token.startswith('"') != token.endswith('"'):
                print("Line %d contains not paired quotes: %s" % (nline, line))
                exit(-1)

            if not token.startswith('"') and token not in valid_token:
                print("Line %d contains unrecognized token: %s" % (nline, token))
                exit(-1)
#
# Skip the specified amount if tokens
#
            if ignor:
                ignor -= 1
                continue

            if token == "asciiHeader":
                nskip = 1
                continue
            if token == "ACCEL_ASCII":
                ignor = 1
                continue
            if token == "(":
                continue

            if state.s == state.STATE_IDLE:
                if token == "netlist":
                    if prev == "(":
                         state.s = state.STATE_NETLIST
                         ignor = 1
                         continue
                sxerr(1, nline, token)

            if state.s == state.STATE_NETLIST:
                if token == ")":
                    state.s = state.STATE_IDLE
                    continue
                if prev == "(":
                    if token == "compInst":
                         comp = tcmp()
                         state.s = state.STATE_COMP
                         continue
                    if token == "net":
                         cnet = tnet()
                         state.s = state.STATE_NET
                         continue
                sxerr(2, nline, token)

            if state.s == state.STATE_COMP:
                if prev == "compInst":
                    if not token.startswith('"'):
                        sxerr(3, nline, token)
                    comp.name = token.strip('"')
                    continue
#
# Adding new component on "compInst" closure
#                
                if token == ")":
                    if prev == ")":
                        state.s = state.STATE_NETLIST
                        if comp.name == "":
                            sxerr(4, nline, token)
                        cmplist[comp.name] = comp
                        ncomp += 1
                        if verb:
                            print("Adding component: %s" % comp.name)
                    continue

                if prev == "(":
                    if token not in valid_comp:
                        sxerr(5, nline, token)
                    continue

                if token.startswith('"'):
                    if prev not in valid_comp:
                        sxerr(6, nline, token)
                    comp.attr[prev] = token.strip('"')
                    continue
                sxerr(7, nline, token)

            if state.s == state.STATE_NET:
                if prev == "net":
                    if not token.startswith('"'):
                        sxerr(8, nline, token)
                    cnet.name = token.strip('"')
                    continue
#
# Adding new net on "net" closure
#                
                if token == ")":
                    if prev == ")":
                        state.s = state.STATE_NETLIST
                        if cnet.name == "":
                            sxerr(9, nline, token)
                        netlist[cnet.name] = cnet
                        nnet += 1
                        if verb:
                            print("Adding net: %s" % cnet.name)
                    continue

                if prev == "(":
                    if token != "node":
                        sxerr(10, nline, token)
                    continue
#
# Open new node list
#                
                if token.startswith('"') and prev == "node":
                    state.s = state.STATE_NODE
                    compName = token.strip('"')
                    comp = cmplist.get(compName, None)
                    if comp == None:
                        print("Component \"%s\" not found in line %d" % (compName, nline))
                        exit(-1)
                    pins = []
                    continue
                sxerr(11, nline, token)

            if state.s == state.STATE_NODE:
                if token == ")":
                    if not pins:
                        sxerr(12, nline, token)
                    cnet.nodes[compName] = pins
                    state.s = state.STATE_NET
                    continue

                if not token.startswith('"'):
                   sxerr(11, nline, token)
                npin = int(token.strip('"'))
                pins.append(npin)
                comp.pins[npin] = cnet.name
                continue

            printf("Invalid state %d", state.s)
            exit(-1)

    if nskip or ignor:
        print("Unexpected end of file (not closed skip)")
        exit(-1)

    print("%d lines, %d components, %d nets" % (nline, ncomp, nnet))
    return netlist, cmplist

def comp_by_pin(vnet, npin):
    rcmp = None
    for key in vnet.nodes:
        node = vnet.nodes[key]
        if len(node) == 1 and node[0] == npin:
            if rcmp != None:
                print("Duplicated component in net", vnet)
                exit(-1)
            rcmp = copy.copy(key)
    if rcmp != None:
        rcmp = cmplist[rcmp]
    return rcmp

def proc_1621(arch, verb):
    vlist = []
    vdict = {}
    vlitc = {}
    for i in range(88):
        vlink = "VLINK_%02d" %  i
        vnet = netlist.get(vlink, None)
        if vnet == None:
            print("Net %s not found in netlist" % vlink)
            exit(-1)
        if verb:
            print(vnet.name, vnet.nodes)
        vcmp = comp_by_pin(vnet, 1)
        if vcmp == None:
            print("No tranceiving component found in net %s" % vnet.name)
            exit(-1)
        pnet = netlist[vcmp.pins[3]]
        seta = 0
        clra = 0
        for t in pnet.nodes:
            nodes = pnet.nodes[t]
            if len(nodes) == 1 and nodes[0] == 3:
                l = cmplist[t].pins[2]
                if re.fullmatch(r"LC\d{1,2}", l):
                    clra |= 1 << int(l[2:])
                if re.fullmatch(r"~LC\d{1,2}", l):
                    seta |= 1 << int(l[3:])
        if seta & clra:
            print("Net: %s bitmask %03X %03X error" % (vnet.name, seta, clra))
            continue
        l = ""
        for j in range(11):
            if seta & (1 << j): 
                l = "1" + l
                continue
            if clra & (1 << j):
                l = "0" + l
                continue
            l = "x" + l
        if verb:
            print("%s: 11'b%s" % (vnet.name, l))
        seta = 0
        for t in vnet.nodes:
            nodes = vnet.nodes[t]
            if len(nodes) == 1 and nodes[0] == 2:
                s = cmplist[t].pins[3]
                if re.fullmatch(r"~TC\d", s):
                    seta |= 1 << int(s[3:])
        vlist.append(l)
        vdict[l] = i
        vlitc[l] = seta

    vlist.sort()
    print("mcp1621 arrays 0/1")
    for l in vlist:
        print("assign pl[%d] = cmp(lc, 11'b%s);" % (vdict[l], l))
    for l in vlist:
        print("11'b%s: tc = 7'x%02X;" % (l, vlitc[l]))

    vlist = []
    vdict = {}
    for i in range(100):
        vlink = "TLINK_%02d" %  i
        vnet = netlist.get(vlink, None)
        if vnet == None: 
            print("Net %s not found in netlist" % vlink)
            exit(-1)
        if verb:
            print(vnet.name, vnet.nodes)
        vcmp = comp_by_pin(vnet, 1)
        if vcmp == None:
            print("No tranceiving component found in net %s" % vnet.name)
            exit(-1)
        print(vcmp)

def proc_netlist(arch, verb):
    print("Processing netlist for arch: %s" % arch)

    if arch == "cp1621": 
        proc_1621(arch, verb)
        return

    print("Unsupported arch: %s" % arch)
    exit(-1)

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("netfile",
                        type=argparse.FileType('r'),
                        help="input netlist file in PCAD-2004 ASCII format")
    parser.add_argument("--arch",
                        choices=["cp1611", "cp1621"],
                        help="architecture used to translate the matrix",
                        default = "cp1621")
    parser.add_argument("--verbose",
                        action="store_true",
                        help="architecture used to translate the matrix")
    args = parser.parse_args()
    read_netlist(args.netfile, args.verbose)
    proc_netlist(args.arch, args.verbose)
    
    args.netfile.close()
    exit(0)
