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
import string
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
                print("Duplicated component in net", vnet.name)
                exit(-1)
            rcmp = copy.copy(key)
    if rcmp != None:
        rcmp = cmplist[rcmp]
    return rcmp

def tc12_expand(l, tc):
    index = str.find(l, 'x')
    if index < 0:
        index = str.find(l, 'b')
        ad = int(l[index+1:index+12], base=2)
        print("   %s: tcr <= 7'h%02X;   // %04o: " % (l, tc, ad))
        return
    str0 = " " + l[:index] + '0' + l[index+1:]
    tc12_expand(str0, tc)
    str1 = " " + l[:index] + '1' + l[index+1:]
    tc12_expand(str1, tc)

def proc_1621_12(arch, verb):
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
                    continue
                if re.fullmatch(r"~LC\d{1,2}", l):
                    seta |= 1 << int(l[3:])
                    continue
                if l == "RNI" or l == "NET00290":
                    continue
                print("Net: %s unrecognized peer %s/%s" % (vnet.name, l, t))
                exit(-1)

        if seta & clra:
            print("Net: %s bitmask %03X %03X error" % (vnet.name, seta, clra))
#
# p[50] and p[75] of array are not used by 1621 LSI-11/03
#
            if vnet.name != "VLINK_50" and vnet.name != "VLINK_75":
                return
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
#
# Check the TC output number of set bits (must be 3 for array 1/2)
#
        nb = 0
        while seta != 0:
            if seta & 0x01:
                nb += 1
            seta >>= 1
        if nb != 3:
            print("Net: %s output %02X error" % (vnet.name, vlitc[l]))

    print("\r\nSorted by product index [1621 arrays 1/2]")
    for l in vlist:
        print("assign pl[%d] = cmp(lc, 11'b%s);" % (vdict[l], l))
    vlist.sort()
    print("\r\nSorted by LC address [1621 arrays 1/2]")
    for l in vlist:
        print("assign pl[%d] = cmp(lc, 11'b%s);" % (vdict[l], l))
    print("\r\nCase table [1621 arrays 1/2]")
    for l in vlist:
        tc12_expand("11'b" + l, vlitc[l])

def proc_1621_34(arch, verb):
    lta = []
    lra = []
    ltsr = []
    tsra = [[], [], []]
    pta = [[], [], [], [], [], [], [], [], [], [], []]

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
        pnet = netlist[vcmp.pins[2]]
        if pnet.name != "V1":
            print("No V1 on tranceiving component found in net %s" % vnet.name)
            exit(-1)

        pnet = netlist[vcmp.pins[3]]
        seta = 0
        clra = 0
        for t in pnet.nodes:
             nodes = pnet.nodes[t]
             if len(nodes) == 1 and nodes[0] == 3:
                l = cmplist[t].pins[2]
                if re.fullmatch(r"TR[0-7]", l):
                    clra |= 1 << int(l[2:])
                    continue
                if re.fullmatch(r"~TR[0-7]", l):
                    seta |= 1 << int(l[3:])
                    continue
                if re.fullmatch(r"TC[0-6]", l):
                    clra |= 1 << (int(l[2:]) + 8)
                    continue
                if re.fullmatch(r"~TC[0-6]", l):
                    seta |= 1 << (int(l[3:]) + 8)
                    continue
                if re.fullmatch(r"IRQ[1-7]", l):
                    clra |= 1 << (int(l[3:]) + 15 - 1)
                    continue
                if re.fullmatch(r"~IRQ[1-7]", l):
                    seta |= 1 << (int(l[4:]) + 15 - 1)
                    continue
                if re.fullmatch(r"TSR[0-1]", l):
                    clra |= 1 << (int(l[3:]) + 22)
                    continue
                if re.fullmatch(r"~TSR[0-1]", l):
                    seta |= 1 << (int(l[4:]) + 22)
                    continue
                if l == "QTR":
                    clra |= 1 << 24
                    continue
                if l == "V1":
                    continue
                print("Net: %s unrecognized peer %s" % (vnet.name, l))
                exit(-1)

        if seta & clra:
            print("Net: %s bitmask %03X %03X error" % (vnet.name, seta, clra))
        if verb:
            print("%s: 25'b%s" % (vnet.name, l))

        tr = ""
        for j in range(0, 8):
            if seta & (1 << j): 
                tr = "1" + tr
                continue
            if clra & (1 << j):
                tr = "0" + tr
                continue
            tr = "x" + tr

        tc = ""
        nb = 0
        for j in range(8, 15):
            if seta & (1 << j): 
                tc = "1" + tc
                nb += 1
                continue
            if clra & (1 << j):
                print("TC: invalid zero in the net %s" % vlink)
                exit(-1)
            tc = "x" + tc
        if nb != 3 and nb != 4:
            print("TC: %s invalid for the net %s" % (tc, vlink))
            exit(-1)

        irq = ""
        for j in range(15, 22):
            if seta & (1 << j): 
                irq = "1" + irq
                continue
            if clra & (1 << j):
                irq = "0" + irq
                continue
            irq = "x" + irq

        tsr = ""
        for j in range(22, 24):
            if seta & (1 << j): 
                tsr = "1" + tsr
                continue
            if clra & (1 << j):
                tsr = "0" + tsr
                continue
            tsr = "x" + tsr

        if clra & (1 << 24):
            q = "0"
        else:
            q = "x"

        if i < 84:
            if irq != "xxxxxxx":
                print("IRQ: %s invalid for the net %s" % (irq, vlink))
                exit(-1)
            print("assign p[%d] = cmp({q, ts, tc, tr}, {1'b%s, 2'b%s, 7'b%s, 8'b%s});"
            % (i, q, tsr, tc, tr))
        else:
            if tr != "xxxxxxxx":
                print("TR: %s invalid for the net %s" % (tr, vlink))
                exit(-1)
            print("assign p[%d] = cmp({q, ts, tc, irq[7:1]}, {1'b%s, 2'b%s, 7'b%s, 8'bx%s});"
            % (i, q, tsr, tc, irq))

        for t in vnet.nodes:
            nodes = vnet.nodes[t]
            vcmp = cmplist[t]
            if len(nodes) != 1:
                print("Multiconnecton: %s %s" % (vlink, t))
                exit -1
            if nodes[0] != 2:
                continue
            if vcmp.pins[3] != "C4":
                print("No C4 found: %s %s" % (vlink, t))
                exit -1
            lname = vcmp.pins.get(1, None)
            if lname == None:
                continue
            if lname == "PLM_LTA":
               lta.append(i)
               continue
            if lname == "PLM_LRA":
               lra.append(i)
               continue
            lnet = netlist[lname]
            for mt in lnet.nodes:
                nodes = lnet.nodes[mt]
                vcmp = cmplist[mt]
                if len(nodes) != 1:
                    print("Multiconnecton: %s %s" % (lnet.name, mt))
                    exit -1
                if nodes[0] != 2:
                    continue
                lname = vcmp.pins[3]
                if lname == "~LDTSRA":
                    ltsr.append(i)
                    continue
                if re.fullmatch(r"~TSRA[0-2]", lname):
                    tsra[int(lname[5:])].append(i)
                    continue
                if re.fullmatch(r"~PTA\d{1,2}", lname):
                    pta[int(lname[4:])].append(i)
                    continue
                print("Net: %s unrecognized peer %s" % (lnet.name, lname))
                exit(-1)

    print("")
    l = "assign lra = "
    for i in lra:
        l = l + "p[%d] | " % i
    print("%s;" % l[:-3])

    l = "assign lta = "
    for i in lta:
        l = l + "p[%d] | " % i
    print("%s;" % l[:-3])

    l = "assign ltsr = "
    for i in ltsr:
        l = l + "p[%d] | " % i
    print("%s;" % l[:-3])

    l = "assign tsr[0] = "
    for i in tsra[0]:
        l = l + "p[%d] | " % i
    print("%s;" % l[:-3])

    l = "assign tsr[1] = "
    for i in tsra[1]:
        l = l + "p[%d] | " % i
    print("%s;" % l[:-3])

    l = "assign tsr[2] = "
    for i in tsra[2]:
        l = l + "p[%d] | " % i
    print("%s;" % l[:-3])
    for j in range(11):
        l = "assign pta[%d] = " % j
        for i in pta[j]:
            l = l + "p[%d] | " % i
        print("%s;" % l[:-3])

def proc_1621_mr(arch, verb):
    print("\r\nMicroinstruction decode array [1621]")
    for i in range(24):
        vlink = "MLINK_%02d" %  i
        vnet = netlist.get(vlink, None)
        if vnet == None: 
            print("Net %s not found in netlist" % vlink)
            exit(-1)
        if verb:
            print(vnet.name, vnet.nodes)
        seta = 0
        clra = 0
        for t in vnet.nodes:
            nodes = vnet.nodes[t]
            if len(nodes) == 1 and nodes[0] == 3:
                l = cmplist[t].pins[2]
                if re.fullmatch(r"MIR\d{1,2}", l):
                    clra |= 1 << int(l[3:])
                    continue
                if re.fullmatch(r"~MIR\d{1,2}", l):
                    seta |= 1 << int(l[4:])
                    continue
                if l == "PLMQ":
                    clra |= 1 << 16
                    continue
                if l == "+5V":
                    continue
                print("Net: %s unrecognized peer %s" % (vnet.name, l))
                exit(-1)

        if seta & clra or seta & 0xFF or clra & 0xFF:
            print("Net: %s bitmask %03X %03X error" % (vnet.name, seta, clra))
            exit(-1)
        seta >>= 8
        clra >>= 8
        l = ""
        for j in range(9):
            if seta & (1 << j): 
                l = "1" + l
                continue
            if clra & (1 << j):
                l = "0" + l
                continue
            l = "x" + l
        if verb:
            print("%s: 11'b%s" % (vnet.name, l))
        print("assign pl[%d] = cmp({plmq, mir[15:8]}, 9'b%s);" % (i, l))

def proc_1611(arch, verb):
    pl_set = [[], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], []]
    pl_clr = [[], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], []]

    for i in range(56):
        vlink = "PLINK_%02d" %  i
        vnet = netlist.get(vlink, None)
        if vnet == None: 
            print("Net %s not found in netlist" % vlink)
            exit(-1)
        if verb:
            print(vnet.name, vnet.nodes)
        vcmp = comp_by_pin(vnet, 3)
        if vcmp == None:
            print("No tranceiving component found in net %s" % vnet.name)
            exit(-1)
        pnet = netlist[vcmp.pins[2]]
        if pnet.name != "V3":
            print("No V3 on tranceiving component found in net %s" % vnet.name)
            exit(-1)
        pnet = netlist[vcmp.pins[1]]
        seta = 0
        clra = 0
        for t in pnet.nodes:
             nodes = pnet.nodes[t]
             if len(nodes) == 1 and nodes[0] == 3:
                l = cmplist[t].pins[2]
                if l == "PSW0":
                    clra |= 1 << 0
                    continue
                if l == "~PSW0":
                    seta |= 1 << 0
                    continue
                if l == "INPL":
                    clra |= 1 << 1
                    continue
                if re.fullmatch(r"MIR\d{1,2}", l):
                    clra |= 1 << int(l[3:])
                    continue
                if re.fullmatch(r"~MIR\d{1,2}", l):
                    seta |= 1 << int(l[4:])
                    continue

        if seta & clra or seta & 0xFC or clra & 0xFC:
            print("Net: %s bitmask %03X %03X error" % (vnet.name, seta, clra))
            exit(-1)

        l = ""
        for j in range(8, 16):
            if seta & (1 << j): 
                l = "1" + l
                continue
            if clra & (1 << j):
                l = "0" + l
                continue
            l = "x" + l
        if clra & 1 << 0:
            l = "0" + l
        else:
            if seta & 1 << 0:
                l = "1" + l
            else:
                l = "x" + l
        if clra & 1 << 1:
            l = "0" + l
        else:
            l = "x" + l

        if verb:
            print("%s: 11'b%s" % (vnet.name, l))
        print("assign p[%d] = cmp({inpl, psw[0], mir[15:8]}, 10'b%s);" % (i, l))

        vcmp = comp_by_pin(vnet, 2)
        if vcmp == None:
            print("No tranceiving component found in net %s" % vnet.name)
            exit(-1)
        pnet = netlist[vcmp.pins[3]]
        if pnet.name != "C3" and pnet.name != "C4":
            print("No C3 on tranceiving component found in net %s" % vnet.name)
            exit(-1)
        pnet = netlist[vcmp.pins[1]]
        if re.fullmatch(r"PL\d{1,2}", pnet.name):
            pl = int(pnet.name[2:])
            pl_set[pl].append(i)
            continue
        for t in pnet.nodes:
            nodes = pnet.nodes[t]
            if len(nodes) == 1 and nodes[0] == 2:
                l = cmplist[t].pins[3]
                if re.fullmatch(r"PL\d{1,2}D", l):
                    pl = int(l[2:-1])
                    pl_clr[pl].append(i)
                    continue
                print("Unrecognized net %s found in net %s" % (l, vnet.name))
                exit(-1)

    print("")
    for i in range(13, 21):
        l = "assign pl[%d] = " % i
        for j in pl_set[i]:
            l = l + "p[%d] | " % j
        print("%s;" % l[:-3])
    print("")
    for i in range(14):
        l = "assign pl_n[%d] = " % i
        for j in pl_clr[i]:
            l = l + "p[%d] | " % j
        print("%s;" % l[:-3])

def proc_netlist(arch, verb):
    print("Processing netlist for arch: %s" % arch)

    if arch == "cp1611": 
        proc_1611(arch, verb)
        return

    if arch == "cp1621": 
        proc_1621_12(arch, verb)
        proc_1621_34(arch, verb)
        proc_1621_mr(arch, verb)
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
                        default = "cp1611")
    parser.add_argument("--verbose",
                        action="store_true",
                        help="architecture used to translate the matrix")
    args = parser.parse_args()
    read_netlist(args.netfile, args.verbose)
    proc_netlist(args.arch, args.verbose)
    
    args.netfile.close()
    exit(0)
