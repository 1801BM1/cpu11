#!/usr/bin/python3
#
# Assembler for Western Digital CP16xx Microcode
# Copyright (c) 2020 Viacheslav Ovsiienko <1801BM1@gmail.com>
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
#
# Mnemonics table is borrowed from:
#   Disassembler for Western Digital CP16xx/WD21xx Microcode
#   Copyright 2015 Eric Smith <spacewar@gmail.com>
#
import os
import re
import sys
import time
import argparse

MIN_LC = 0x0000
MAX_LC = 0x0800

T_SYM = 0
T_REG = 1
T_TRA = 2


class Wd16(object):
    ''' Assembler for Western Digital CP16xx Microcode '''
    #
    # Compiled regular expressions
    #
    RE_OPCODE = re.compile(r'(?:[\.a-zA-Z][a-zA-Z0-9]*\s*)')
    RE_SYMBOL = re.compile(r'(?:[a-zA-Z$_][a-zA-Z0-9$_\.]*\s*=\s*)')
    RE_LABEL = re.compile(r'(?:[a-zA-Z$_][a-zA-Z0-9$_\.]*\s*:\s*)')
    RE_LOCAL = re.compile(r'(?:\d+$)')
    #
    # Operations to calculate expressions
    #
    EXP_OPERS = {
        'U+': (9, lambda x: x),         # unary plus
        'U-': (9, lambda x: -x),        # unary minus
        'U~': (8, lambda x: ~x),        # unary one's complement
        '*': (6, lambda x, y: x * y),   # binary mul
        '/': (6, lambda x, y: x // y),  # binary div
        '+': (5, lambda x, y: x + y),   # binary add
        '-': (5, lambda x, y: x - y),   # binary sub
        '&': (4, lambda x, y: x & y),   # binary and
        '^': (3, lambda x, y: x ^ y),   # binary xor
        '|': (2, lambda x, y: x | y)    # binary or
    }
    EXP_UNA = '+-~'
    EXP_OPS = '+-~*/+-&^|'
    EXP_ALL = '+-~*/+-&^|()'

    def __init__(self):
        self.ps = 0             # pass number
        self.lc = 0             # location counte
        self.radx = 8           # default radix
        self.lnum = 0           # line number
        self.fnam = None        # source file name
        self.fend = 0           # .end directive found
        self.wcnt = 0           # warning counter
        self.ecnt = 0           # error counter
        self.elst = []          # line error list for listing
        self.efst = 0           # first error output
        self.bloc = {}          # local labels block
        self.cloc = {}          # current local block
        self.clin = {}          # local block line number
        self.gval = None        # generated value for listing
        self.data = [-1] * MAX_LC
        self.symb = {           # initialize register names
            'G':     (0, T_REG),
            'GL':    (0, T_REG),
            'GH':    (1, T_REG),
            'RBA':   (2, T_REG),
            'RBAL':  (2, T_REG),
            'RBAH':  (3, T_REG),
            'RSRC':  (4, T_REG),
            'RSRCL': (4, T_REG),
            'RSRCH': (5, T_REG),
            'RDST':  (6, T_REG),
            'RDSTL': (6, T_REG),
            'RDSTH': (7, T_REG),
            'RIR':   (8, T_REG),
            'RIRL':  (8, T_REG),
            'RIRH':  (9, T_REG),
            'RPSW':  (10, T_REG),
            'RPSWL': (10, T_REG),
            'RPSWH': (11, T_REG),
            'SP':    (12, T_REG),
            'SPL':   (12, T_REG),
            'SPH':   (13, T_REG),
            'PC':    (14, T_REG),
            'PCL':   (14, T_REG),
            'PCH':   (15, T_REG),
            'I4':    (1, T_SYM),
            'I5':    (2, T_SYM),
            'I6':    (4, T_SYM),
            'C':     (1, T_SYM),
            'V':     (2, T_SYM),
            'Z':     (4, T_SYM),
            'N':     (8, T_SYM),
            'C8':    (16, T_SYM),
            'C4':    (32, T_SYM),
            'ZB':    (64, T_SYM),
            'NB':    (128, T_SYM),
            'UB':    (0, T_SYM),
            'LB':    (1, T_SYM),
            'UBC':   (2, T_SYM),
            'LBC':   (3, T_SYM),
            'RMW':   (4, T_SYM),
            'TG6':   (1, T_SYM),
            'TG8':   (2, T_SYM),
            'LRR':   (1, T_SYM),
            'RSVC':  (2, T_SYM)
        }
        return

    def dir_title(self, opcode, word):
        #
        # Ignore .title for compatibility
        #
        return -1

    def dir_radix(self, opcode, word):
        radx = self.eval_exp(opcode[1])
        #
        # radix 16 is not supported to avoid digits and names
        # misinterpreting, i.e. DEAD0 might represent both
        #
        if radx not in (8, 10):
            raise SyntaxError("unsupported radix value '%d'" % radx)
        self.radx = radx
        return -1

    def dir_tran(self, opcode, word):
        arg = opcode[1]
        tran = self.eval_exp(arg)
        qt = self.symb.get(arg)
        if qt is not None and (qt[0] != tran or qt[1] != T_TRA):
            raise SyntaxError("translation definition duplication '%s'" % arg)
        if self.ps == 1:
            self.symb[arg] = (tran, T_TRA)
        self.gval = tran
        return -1

    def dir_reg(self, opcode, word):
        arg = opcode[1]
        reg = self.eval_exp(arg)
        if not 0 <= reg < 16:
            raise SyntaxError("register is out of range %d" % reg)
        qr = self.symb.get(arg)
        if qr is not None and (qr[0] != reg or qr[1] != T_REG):
            raise SyntaxError("register definition duplication '%s'" % arg)
        if self.ps == 1:
            self.symb[arg] = (reg, T_REG)
        self.gval = reg
        return -1

    def dir_loc(self, opcode, word):
        loc = self.eval_exp(opcode[1])
        #
        # Allow counter to get any value
        # Check will happen on actual usage
        #
        self.lc = loc
        return -1

    def dir_align(self, opcode, word):
        pw2 = self.eval_exp(opcode[1])
        mask = (1 << pw2) - 1
        if not MIN_LC <= mask < MAX_LC or pw2 >= 16:
            raise SyntaxError("aligment is out of range 0x%08X" % mask)
        self.lc += mask
        self.lc &= ~mask
        return -1

    def dir_end(self, opcode, word):
        self.fend = 1
        return -1

    def get_reg(self, sym):
        reg = self.symb.get(sym)
        if reg is None:
            raise SyntaxError("undefined register name '%s'" % sym)
        if reg[1] != T_REG:
            raise SyntaxError("unregistered as register name '%s'" % sym)
        if not 0 <= reg[0] < 16:
            raise SyntaxError("register is out of range '%s'" % sym)
        return reg[0]

    def op_jmp(self, opcode, word):
        addr = self.eval_exp(opcode[1])
        if not MIN_LC <= addr < MAX_LC:
            raise SyntaxError("address is out of range 0x%08X" % addr)
        return word | addr

    #
    # For conditional jump we should check the upper byte
    # of target address against current one, at the moment
    # of jump is taket the lc is alredy incremented
    #
    def op_jxx(self, opcode, word):
        addr = self.eval_exp(opcode[1])
        if not MIN_LC <= addr < MAX_LC:
            raise SyntaxError("address is out of range 0x%08X" % addr)
        if ((self.lc + 1) ^ addr) & ~0xFF:
            raise SyntaxError("conditional jump is out of range 0x%08X" % addr)
        return word | (addr & 0xFF)

    def op_non(self, opcode, word):
        return word

    def op_lit(self, opcode, word):
        lit = self.eval_exp(opcode[1])
        if not 0 <= lit < 0x100:
            raise SyntaxError("literal is out of range 0x%08X" % lit)
        reg = self.get_reg(opcode[2])
        return word | reg | lit << 4

    def op_xi(self, opcode, word):
        mask = self.eval_exp(opcode[1])
        if not 0 <= mask < 8:
            raise SyntaxError("interrupt mask is out of range 0x%08X" % mask)
        return word | mask << 4

    def op_ra(self, opcode, word):
        reg = self.get_reg(opcode[1])
        return word | reg

    def op_rba(self, opcode, word):
        rb = self.get_reg(opcode[1])
        ra = self.get_reg(opcode[2])
        return word | ra | rb << 4

    def op_in(self, opcode, word):
        if opcode[0] in ('ib', 'ibf', 'iw', 'iwf'):
            lim = 8
        else:
            lim = 4
        #
        # The mode operand is allowed to be empty, default is 0
        #
        if opcode[1]:
            mode = self.eval_exp(opcode[1])
        else:
            mode = 0
        if not 0 <= mode < lim:
            raise SyntaxError("I/O mode is out of range 0x%08X" % mode)
        ra = self.get_reg(opcode[2])
        return word | ra | mode << 4

    dir_ops = {
        'jmp':   (0x0000, 1, op_jmp),   # unconditional JuMP
        'rfs':   (0x0800, 0, op_non),   # Return From Subroutine
        'jzbf':  (0x1000, 1, op_jxx),   # Jump if ZB flag is False
        'jzbt':  (0x1100, 1, op_jxx),   # Jump if ZB flag is True
        'jc8f':  (0x1200, 1, op_jxx),   # Jump if C8 flag is False
        'jc8t':  (0x1300, 1, op_jxx),   # Jump if C8 flag is True
        'jif':   (0x1400, 1, op_jxx),   # Jump if Indirect condition is False
        'jit':   (0x1500, 1, op_jxx),   # Jump if Indirect condition is True
        'jnbf':  (0x1600, 1, op_jxx),   # Jump if NB flag False
        'jnbt':  (0x1700, 1, op_jxx),   # Jump if NB flag True
        'jzf':   (0x1800, 1, op_jxx),   # Jump if Z flag False
        'jzt':   (0x1900, 1, op_jxx),   # Jump if Z flag True
        'jcf':   (0x1a00, 1, op_jxx),   # Jump if C flag False
        'jct':   (0x1b00, 1, op_jxx),   # Jump if C flag True
        'jvf':   (0x1c00, 1, op_jxx),   # Jump if V flag False
        'jvt':   (0x1d00, 1, op_jxx),   # Jump if V flag True
        'jnf':   (0x1e00, 1, op_jxx),   # Jump if N flag False
        'jnt':   (0x1f00, 1, op_jxx),   # Jump if N flag True

        'al':    (0x2000, 2, op_lit),   # Add Literal
        'cl':    (0x3000, 2, op_lit),   # Compare Literal
        'nl':    (0x4000, 2, op_lit),   # aNd Literal
        'tl':    (0x5000, 2, op_lit),   # Test Literal
        'll':    (0x6000, 2, op_lit),   # Load Literal

        'ri':    (0x7000, 1, op_xi),    # Reset Interrupts
        'si':    (0x7100, 1, op_xi),    # Set Interrupts
        'ccf':   (0x7200, 1, op_ra),    # Copy Condition Flags
        'lcf':   (0x7300, 2, op_rba),   # Load Condition Flags
        'rtsr':  (0x7400, 0, op_non),   # Reset Translation State Register
        'lgl':   (0x7500, 1, op_ra),    # Load G Low
        'cib':   (0x7600, 1, op_ra),    # Conditionally Increment Byte
        'cdb':   (0x7700, 1, op_ra),    # Conditionally Decrement Byte

        'mb':    (0x8000, 2, op_rba),   # Move Byte
        'mbf':   (0x8100, 2, op_rba),   # Move Byte, Flags
        'mw':    (0x8200, 2, op_rba),   # Move Word
        'mwf':   (0x8300, 2, op_rba),   # Move Word, Flags
        'cmb':   (0x8400, 2, op_rba),   # Conditionally Move Byte
        'cmbf':  (0x8500, 2, op_rba),   # Conditionally Move Byte, Flags
        'cmw':   (0x8600, 2, op_rba),   # Conditionally Move Word
        'cmwf':  (0x8700, 2, op_rba),   # Conditionally Move Word, Flags
        'slbc':  (0x8800, 2, op_rba),   # Shift Left Byte with Carry
        'slbcf': (0x8900, 2, op_rba),   # Shift Left Byte with Carry, Flags
        'slwc':  (0x8a00, 2, op_rba),   # Shift Left Word with Carry
        'slwcf': (0x8b00, 2, op_rba),   # Shift Left Word with Carry, Flags
        'slb':   (0x8c00, 2, op_rba),   # Shift Left Byte
        'slbf':  (0x8d00, 2, op_rba),   # Shift Left Byte, Flags
        'slw':   (0x8e00, 2, op_rba),   # Shift Left Word
        'slwf':  (0x8f00, 2, op_rba),   # Shift Left Word, Flags

        'icb1':  (0x9000, 2, op_rba),   # Increment Byte By 1
        'icb1f': (0x9100, 2, op_rba),   # Increment Byte By 1, Flags
        'icw1':  (0x9200, 2, op_rba),   # Increment Word By 1
        'icw1f': (0x9300, 2, op_rba),   # Increment Word By 1, Flags
        'icb2':  (0x9400, 2, op_rba),   # Increment Byte By 2
        'icb2f': (0x9500, 2, op_rba),   # Increment Byte By 2, Flags
        'icw2':  (0x9600, 2, op_rba),   # Increment Word By 2
        'icw2f': (0x9700, 2, op_rba),   # Increment Word By 2, Flags
        'tcb':   (0x9800, 2, op_rba),   # Twos Complement Byte
        'tcbf':  (0x9900, 2, op_rba),   # Twos Complement Byte, Flags
        'tcw':   (0x9a00, 2, op_rba),   # Twos Complement Word
        'tcwf':  (0x9b00, 2, op_rba),   # Twos Complement Word, Flags
        'ocb':   (0x9c00, 2, op_rba),   # Ones Complement Byte
        'ocbf':  (0x9d00, 2, op_rba),   # Ones Complement Byte, Flags
        'ocw':   (0x9e00, 2, op_rba),   # Ones Complement Word
        'ocwf':  (0x9f00, 2, op_rba),   # Ones Complement Word, Flags

        'ab':    (0xa000, 2, op_rba),   # Add Byte
        'abf':   (0xa100, 2, op_rba),   # Add Byte, Flags
        'aw':    (0xa200, 2, op_rba),   # Add Word
        'awf':   (0xa300, 2, op_rba),   # Add Word, Flags
        'cab':   (0xa400, 2, op_rba),   # Conditionally Add Byte
        'cabf':  (0xa500, 2, op_rba),   # Conditionally Add Byte, Flags
        'caw':   (0xa600, 2, op_rba),   # Conditionally Add Word
        'cawf':  (0xa700, 2, op_rba),   # Conditionally Add Word, Flags
        'abc':   (0xa800, 2, op_rba),   # Add Byte with Carry
        'abcf':  (0xa900, 2, op_rba),   # Add Byte with Carry, Flags
        'awc':   (0xaa00, 2, op_rba),   # Add Word with Carry
        'awcf':  (0xab00, 2, op_rba),   # Add Word with Carry, Flags
        'cad':   (0xac00, 2, op_rba),   # Conditionally Add Digits
        'cawi':  (0xae00, 2, op_rba),   # Conditionally Add Word on Icc
        'cawif': (0xaf00, 2, op_rba),   # Conditionally Add Word on Icc, Flags

        'sb':    (0xb000, 2, op_rba),   # Subtract Byte
        'sbf':   (0xb100, 2, op_rba),   # Subtract Byte, Flags
        'sw':    (0xb200, 2, op_rba),   # Subtract Word
        'swf':   (0xb300, 2, op_rba),   # Subtract Word, Flags
        'cb':    (0xb400, 2, op_rba),   # Compare Byte
        'cbf':   (0xb500, 2, op_rba),   # Compare Byte, Flags
        'cw':    (0xb600, 2, op_rba),   # Compare Word
        'cwf':   (0xb700, 2, op_rba),   # Compare Word, Flags
        'sbc':   (0xb800, 2, op_rba),   # Subtract Byte with Carry
        'sbcf':  (0xb900, 2, op_rba),   # Subtract Byte with Carry, Flags
        'swc':   (0xba00, 2, op_rba),   # Subtract Word with Carry
        'swcf':  (0xbb00, 2, op_rba),   # Subtract Word with Carry, Flags
        'db1':   (0xbc00, 2, op_rba),   # Decrement Byte by 1
        'db1f':  (0xbd00, 2, op_rba),   # Decrement Byte by 1, Flags
        'dw1':   (0xbe00, 2, op_rba),   # Decrement Word by 1
        'dw1f':  (0xbf00, 2, op_rba),   # Decrement Word by 1, Flags

        'nb':    (0xc000, 2, op_rba),   # aNd Byte
        'nbf':   (0xc100, 2, op_rba),   # aNd Byte, Flags
        'nw':    (0xc200, 2, op_rba),   # aNd Word
        'nwf':   (0xc300, 2, op_rba),   # aNd Word, Flags
        'tb':    (0xc400, 2, op_rba),   # Test Byte
        'tbf':   (0xc500, 2, op_rba),   # Test Byte, Flags
        'tw':    (0xc600, 2, op_rba),   # Test Word
        'twf':   (0xc700, 2, op_rba),   # Test Word, Flags
        'orb':   (0xc800, 2, op_rba),   # OR Byte
        'orbf':  (0xc900, 2, op_rba),   # OR Byte, Flags
        'orw':   (0xca00, 2, op_rba),   # OR Word
        'orwf':  (0xcb00, 2, op_rba),   # OR Word, Flags
        'xb':    (0xcc00, 2, op_rba),   # eXclusive or Byte
        'xbf':   (0xcd00, 2, op_rba),   # eXclusive or Byte, Flags
        'xw':    (0xce00, 2, op_rba),   # eXclusive or Word
        'xwf':   (0xcf00, 2, op_rba),   # eXclusive or Word, Flags

        'ncb':   (0xd000, 2, op_rba),   # aNd Complement Byte
        'ncbf':  (0xd100, 2, op_rba),   # aNd Complement Byte, Flags
        'ncw':   (0xd200, 2, op_rba),   # aNd Complement Word
        'ncwf':  (0xd300, 2, op_rba),   # aNd Complement Word, Flags
        'srbc':  (0xd800, 2, op_rba),   # Shift Right Byte with Carry
        'srbcf': (0xd900, 2, op_rba),   # Shift Right Byte with Carry, Flags
        'srwc':  (0xda00, 2, op_rba),   # Shift Right Word with Carry
        'srwcf': (0xdb00, 2, op_rba),   # Shift Right Word with Carry, Flags
        'srb':   (0xdc00, 2, op_rba),   # Shift Right Byte
        'srbf':  (0xdd00, 2, op_rba),   # Shift Right Byte, Flags
        'srw':   (0xde00, 2, op_rba),   # Shift Right Word
        'srwf':  (0xdf00, 2, op_rba),   # Shift Right Word, Flags

        'ib':    (0xe000, 2, op_in),    # Input Byte
        'ibf':   (0xe100, 2, op_in),    # Input Byte, Flags
        'iw':    (0xe200, 2, op_in),    # Input Word
        'iwf':   (0xe300, 2, op_in),    # Input Word, Flags
        'isb':   (0xe400, 2, op_in),    # Input Status Byte
        'isbf':  (0xe500, 2, op_in),    # Input Status Byte, Flags
        'isw':   (0xe600, 2, op_in),    # Input Status Word
        'iswf':  (0xe700, 2, op_in),    # Input Status Word, Flags
        'mi':    (0xec00, 2, op_rba),   # Modify microInstruction
        'ltr':   (0xee00, 2, op_rba),   # Load Translation Register

        'rib1':  (0xf000, 2, op_rba),   # Read and Increment Byte by 1
        'wib1':  (0xf100, 2, op_rba),   # Write and Increment Byte by 1
        'riw1':  (0xf200, 2, op_rba),   # Read and Increment Word by 1
        'wiw1':  (0xf300, 2, op_rba),   # Write and Increment Word by 1
        'rib2':  (0xf400, 2, op_rba),   # Read and Increment Byte by 2
        'wib2':  (0xf500, 2, op_rba),   # Write and Increment Byte by 2
        'riw2':  (0xf600, 2, op_rba),   # Read and Increment Word by 2
        'wiw2':  (0xf700, 2, op_rba),   # Write and Increment Word by 2
        'r':     (0xf800, 2, op_rba),   # Read
        'w':     (0xf900, 2, op_rba),   # Write
        'ra':    (0xfa00, 2, op_rba),   # Read Acknowledge
        'wa':    (0xfb00, 2, op_rba),   # Write Acknowledge
        'ob':    (0xfc00, 2, op_rba),   # Output Byte
        'ow':    (0xfd00, 2, op_rba),   # Output Word
        'os':    (0xfe00, 2, op_rba),   # Output Status
        'nop':   (0xff00, 0, op_non),   # No OPeration

        '.title': (-1, 1, dir_title),   # .reg
        '.radix': (-1, 1, dir_radix),   # .reg
        '.align': (-1, 1, dir_align),   # .reg
        '.tran':  (-1, 1, dir_tran),    # .reg
        '.reg':   (-1, 1, dir_reg),     # .reg
        '.loc':   (-1, 1, dir_loc),     # .loc
        '.end':   (-1, 0, dir_end),     # .end
    }

    #
    # Calculates the expression in Polish Reverse Notation
    #
    def calc_exp(self, polish):
        stack = []
        for token in polish:
            if token in Wd16.EXP_OPERS:
                if token[0] == 'U':
                    x = stack.pop()
                    stack.append(Wd16.EXP_OPERS[token][1](x))
                else:
                    y, x = stack.pop(), stack.pop()
                    stack.append(Wd16.EXP_OPERS[token][1](x, y))
            else:
                stack.append(token)
        if not stack:
            raise SyntaxError("invalid integer expression (empty)")
        return stack[0]

    #
    # Converts the infix expression to Polish Reverse Notation
    #
    def polish_exp(self, string):
        stack = []
        for token in string:
            if token in Wd16.EXP_OPERS:
                while (stack and stack[-1] != "(" and
                        Wd16.EXP_OPERS[token][0] <=
                        Wd16.EXP_OPERS[stack[-1]][0]):
                    yield stack.pop()
                stack.append(token)
            elif token == ")":
                while stack:
                    x = stack.pop()
                    if x == "(":
                        break
                    yield x
            elif token == "(":
                stack.append(token)
            else:
                yield token
        while stack:
            yield stack.pop()

    #
    # Token generator wrapper, replaces [+-~] with unary tags
    #
    def subst_unary(self, string):
        prev = True
        for token in string:
            if type(token) is not str:
                prev = False
                yield token
                continue
            if token in Wd16.EXP_UNA:
                if prev:
                    yield 'U' + token
            else:
                prev = token in Wd16.EXP_OPS or token == '('
                yield token

    #
    # Token generator wrapper, replaces the numbers with actual integers
    #
    def subst_number(self, token):
        try:
            lt = len(token)
            if token[0] == '0':
                if lt > 1:
                    if token[1] in 'xX':
                        return int(token[2:], base=16)
                    if token[1] in 'bB':
                        return int(token[2:], base=2)
                    if token[-1] == '.':
                        return int(token[:-1], base=10)
                    return int(token[:-1], base=8)
            if token[-1] == '.':
                return int(token[:-1], base=10)
            return int(token, self.radx)
        except ValueError:
            raise SyntaxError("invalid integer expression '%s'" % token)

    #
    # Token generator wrapper, replaces the symbols with actual integers
    #
    def subst_symbol(self, string):
        for token in string:
            if token in Wd16.EXP_ALL:
                yield token
            elif token[0] in '0123456789':
                yield self.subst_number(token)
            else:
                value = self.symb.get(token)
                if value is None:
                    raise SyntaxError("undefined identifier '%s'" % token)
                yield value[0]

    #
    # Source token generator parses the original line
    #
    def parse_exp(self, string):
        start = -1
        pos = -1
        for s in string:
            pos += 1
            if start < 0:
                if s in ' \t':
                    continue
                start = pos
            if s.isalnum() or s in '$_.':
                continue
            if start >= 0:
                yield string[start:pos]
                start = -1
            if s in Wd16.EXP_ALL:
                yield s
        if start >= 0:
            yield string[start:]

    #
    # Evaluate arithmetics expression, returns integer if succeeded,
    # otherwise throws SyntaxError with error message generated
    #
    def eval_exp(self, exp):
        value = self.calc_exp(                      # calculate polish
                  self.polish_exp(                  # convert to polish
                    self.subst_unary(               # convert unary
                      self.subst_symbol(            # subst symbols
                        self.parse_exp(exp)))))     # generate tokens
        return value

    def open_file(self, name, ext, mode):
        #
        # Add the default file name extension if needed
        #
        sname = os.path.splitext(name)
        if not sname[1]:
            name += '.' + ext
        self.fnam = name
        try:
            file = open(name, mode, -1, None, None)
        except OSError as err:
            raise RuntimeError(err)
        return file

    def close_file(self, file):
        if file is not None:
            file.close()
        return

    #
    # Prints the specified symbol cathegoty into listing
    #
    def final_dict(self, title, t, fl):
        maxl = 0
        nl = []
        for s in self.symb:
            sy = self.symb[s]
            if sy[1] == t:
                nl.append(s)
                maxl = max(maxl, len(s))
        nl.sort()
        numl = len(nl)
        if numl:
            print("\r\n%s: %d entries" % (title, numl), file=fl)
            ncol = max(80 // (maxl + 14), 1)
            nlin = (numl + ncol - 1) // ncol
            for i in range(nlin):
                s = ''
                for j in range(ncol):
                    idx = i * nlin + j
                    if idx < numl:
                        if j:
                            s += ' ' * 4
                        s += nl[idx].ljust(maxl + 2)
                        s += '%08X' % self.symb[nl[idx]][0]
                if s:
                    print(s, file=fl)
        return

    #
    # Show final compilation statistics
    #
    def final_stat(self, flst):
        msg = '\r\nErrors: %d\r\nWarnings: %d\r\n' % (self.ecnt, self.wcnt)
        if self.ecnt or self.wcnt:
            print(msg, file=sys.stderr)
        if flst is not None:
            self.final_dict("Register definitions", T_REG, flst)
            self.final_dict("Translation definitions", T_TRA, flst)
            self.final_dict("Symbol definitions", T_SYM, flst)
            print(msg, file=flst)
        return

    #
    # Store error information for the listing after the line
    #
    def log_error(self, emsg, ps=2):
        if ps in (0, self.ps):
            if self.efst == 0:
                print('', file=sys.stderr)
                self.efst = 1
            msg = '*** Error[%d]: %s' % (self.lnum, emsg)
            print(msg, file=sys.stderr)
            self.elst.append(msg)
            self.ecnt += 1
        return

    def log_warning(self, emsg, ps=2):
        if ps in (0, self.ps):
            if self.efst == 0:
                print('', file=sys.stderr)
                self.efst = 1
            msg = '*** Warning[%d]: %s' % (self.lnum, emsg)
            print(msg, file=sys.stderr)
            self.elst.append(msg)
            self.wcnt += 1
        return

    #
    # Process the local label block boundary
    #
    def local_block(self):
        if self.ps == 1:
            if self.cloc:
                self.bloc[self.clin] = self.cloc.copy()
            self.cloc = {}
        else:
            self.cloc = self.bloc.get(self.lnum, {})
        self.clin = self.lnum
        return

    #
    # Assign the local or generic label with local counter
    #
    def assign_label(self, label):
        match = Wd16.RE_LOCAL.match(label)
        if match is not None:
            #
            # Local label processing
            #
            if self.ps == 1:
                if label in self.cloc:
                    raise SyntaxError("label duplication '%s'" % label)
                self.cloc[label] = self.lc
            else:
                if self.cloc.get(label, -1) != self.lc:
                    raise SyntaxError("label phase mismatch '%s'" % label)
        else:
            #
            # Generic label processing
            #
            label = label.upper()
            lc = self.symb.get(label)
            if self.ps == 1:
                if lc is not None:
                    raise SyntaxError("label duplication '%s'" % label)
                self.symb[label] = (self.lc, T_SYM)
            else:
                if lc is None or lc[0] != self.lc or lc[1] != T_SYM:
                    raise SyntaxError("label phase mismatch '%s'" % label)
        return

    #
    # Assign the value to symbol in "symbol = value"
    #
    def assign_symbol(self, symbol, exp):
        symbol = symbol.upper()
        value = self.eval_exp(exp)
        qs = self.symb.get(symbol)
        if self.ps == 1:
            if qs is not None:
                raise SyntaxError("symbol duplication '%s'" % symbol)
            self.symb[symbol] = (value, T_SYM)
        else:
            if qs is None:
                self.symb[symbol] = (value, T_SYM)
            else:
                if qs[0] != value or qs[1] != T_SYM:
                    raise SyntaxError("symbol phase mismatch '%s'" % symbol)
            self.gval = value
        return

    #
    # Field generator - splits on ',' accounting quotas, slashes, comments
    #
    def parse_gen(self, string):
        start = -1
        quota = 0
        slash = 0
        pos = -1
        for s in string:
            pos += 1
            if start < 0:
                if s in ' \t':
                    continue
                if s == ',':
                    yield ''
                    start = -1
                    quota = 0
                    slash = 0
                    continue
                if s == ';':
                    break
                start = pos
            if quota == 0:
                if s == ',':
                    yield string[start:pos]
                    start = -1
                    quota = 0
                    slash = 0
                    continue
                if s == ';':
                    if pos != start:
                        yield string[start:pos]
                    start = -1
                    break
                if s == "'":
                    quota = 1
                elif s == '"':
                    quota = 2
                continue
            if slash:
                slash = 0
                continue
            if s == '\\':
                slash = 1
                continue
            if quota == 1:
                if s == "'":
                    quota = 0
            else:
                if s == '"':
                    quota = 0
        if start >= 0:
            yield string[start:]

    #
    # Parse the optional parameters after opcode/directive
    #
    def parse_args(self, opcode, line):
        for field in self.parse_gen(line):
            field = field.strip(' \t')
            if field and field[0] not in '\'\"':
                field = field.upper()
            opcode.append(field)
        return opcode

    def insert_data(self, data):
        if not MIN_LC <= self.lc < MAX_LC:
            raise SyntaxError("Location is out of range '0x%04X'" % self.lc)
        if self.data[self.lc] >= 0 and self.data[self.lc] != data:
            raise SyntaxError("Location multiple commit '0x%04X'" % self.lc)
        self.data[self.lc] = data
        return

    def do_opcode(self, opcode):
        oc = opcode[0]
        obj = Wd16.dir_ops.get(oc.lower())
        if obj is None:
            raise SyntaxError("invalid command or directive '%s'" % oc[0])
        narg = len(opcode) - 1
        if narg < obj[1]:
            raise SyntaxError("not enough parameters for '%s'" % oc[0])
        if obj[0] < 0:
            if narg > obj[1]:
                raise SyntaxError("too many directive parameters '%s'" % oc[0])
        elif narg > (obj[1] + 2):
            raise SyntaxError("too many parameters for '%s'" % oc[0])
        narg -= obj[1]
        word = obj[0]
        if narg >= 1:
            #
            # Handle the LRR, RSVC and TTL bit field
            #
            oc = opcode[obj[1]+1]
            if oc and self.ps == 2:
                ext = self.eval_exp(oc)
                if ext & ~0x3F:
                    raise SyntaxError("extension is out of range 0x%X" % ext)
                word |= ext << 16
        if narg >= 2:
            #
            # Handle the translation code field
            #
            oc = opcode[obj[1]+2]
            if oc and self.ps == 2:
                ext = self.symb.get(oc)
                if ext is None or ext & ~0x7F:
                    raise SyntaxError("invalid translation code '%s'" % oc)
                word |= ext << 24
        try:
            word = obj[2](self, opcode, word)
        except SyntaxError as err:
            if obj[0] < 0:
                raise err
            self.log_error(err)
            return 0
        if word >= 0:
            self.gval = word
        return word

    #
    # Compile the single source line
    #
    def do_line(self, line):
        self.gval = None
        self.elst = []
        #
        # Skip empty line
        #
        if not line:
            return
        #
        # Detect local label block boundary
        #
        if line[0] not in ' \t;0123456789':
            self.local_block()
        line = line.strip(' \t')
        #
        # Match on optional present label "labels:"
        #
        match = Wd16.RE_LABEL.match(line)
        if match is not None:
            label = match.group().rstrip(' \t:')
            line = line[match.end():]
            self.assign_label(label)
            if not line:
                return
        #
        # Match on variable assignment "var = exp"
        #
        match = Wd16.RE_SYMBOL.match(line)
        if match is not None:
            label = match.group().rstrip(' \t=')
            line = line[match.end():]
            self.assign_symbol(label, line)
            return
        #
        # Match on opcode or assembler directive
        #
        match = Wd16.RE_OPCODE.match(line)
        if match is None:
            if line[0] == ';':
                return
            raise SyntaxError("syntax error")
        opcode = [match.group().rstrip(' \t')]
        line = line[match.end():]
        opcode = self.parse_args(opcode, line)
        word = self.do_opcode(opcode)
        if word >= 0:
            if self.ps == 2:
                self.insert_data(word)
            self.lc += 1
        return

    def do_list(self, line, flst):
        if flst is not None:
            if self.gval is None:
                val = ' ' * 8
            else:
                val = '%08X' % self.gval
            print("%5d  %03X  %s\t\t%s" %
                  (self.lnum, self.lc, val, line), file=flst)
            for emsg in self.elst:
                print("%s" % emsg, file=flst)
        return

    #
    # Set the pass number and reinit the parser
    #
    def set_pass(self, ps):
        self.ps = ps
        self.lc = 0
        self.ecnt = 0
        self.wcnt = 0
        self.lnum = 0
        self.clin = 0
        self.cloc = self.bloc.get(0, {})
        return

    #
    # Process one source file
    #
    def do_assembly(self, fsrc, flst):
        if self.ps == 2 and flst is not None:
            print('00000  Time: %s  ' % time.ctime(),
                  'File: %s\r\n' % self.fnam.upper(), file=flst)
        self.fend = 0
        for line in fsrc:
            self.lnum += 1
            line = line.strip('\r\n')

            try:
                self.do_line(line)
            except SyntaxError as err:
                self.log_error(err)

            if self.ps == 2 and flst is not None:
                self.do_list(line, flst)
            if self.fend:
                break
        self.local_block()
        if self.fend == 0:
            self.elst = []
            self.log_warning("missing '.end' directive")
            if flst is not None:
                print('%s' % self.elst[0], file=flst)
        return

    def write_obj(self, fobj, width):
        msk = (1 << width) - 1
        lim = -1
        for i in range(MAX_LC):
            if self.data[i] >= 0:
                lim = i
        if lim < 0:
            return
        lim += 1
        print('DEPTH = %d;\r\n'
              'WIDTH = %d;\r\n'
              'ADDRESS_RADIX = HEX;\r\n'
              'DATA_RADIX = HEX;\r\n'
              'CONTENT BEGIN' % (lim, width), file=fobj)
        for i in range(lim):
            data = self.data[i]
            if data >= 0:
                print('%03X: %06X;' % (i, data & msk), file=fobj)
        print('END;',  file=fobj)
        return

    def write_ttl(self, fttl):
        head = False
        msk = 0x0F << 18
        for i in range(MAX_LC):
            data = self.data[i]
            if data >= 0 and data & msk:
                data &= msk
                if not head:
                    print('TTL locations:', file=fttl)
                    head = True
                print('%03X: %08X, %1X;' % (i, data, data >> 18), file=fttl)
        head = False
        msk = 0xFF << 24
        for i in range(MAX_LC):
            data = self.data[i]
            if data >= 0 and data & msk:
                data &= msk
                if not head:
                    print('TRA locations:', file=fttl)
                    head = True
                print('%03X: %08X, %02X;' % (i, data, data >> 24), file=fttl)
        return


def createParser():
    p = argparse.ArgumentParser(
        description='Western Digital MCP-1600 Microcode Assembler, '
                    'Version 20.05a, (c) 1801BM1')
    p.add_argument('src', nargs='+',
                   help='input source file(s)', metavar='file [file ...]')
    p.add_argument('-l', '--lst', help='output listing file', metavar='file')
    p.add_argument('-o', '--obj', help='output object file', metavar='file')
    p.add_argument('-t', '--ttl', help='output TTL-logic file', metavar='file')
    return p


def main():
    parser = createParser()
    params = parser.parse_args()

    try:
        asm = Wd16()
        #
        # Check all source files existance
        #
        for src in params.src:
            fsrc = asm.open_file(src, 'mic', 'r')
            asm.close_file(fsrc)
        #
        # Do the first pass for all sources
        #
        asm.set_pass(1)
        for src in params.src:
            fsrc = asm.open_file(src, 'mic', 'r')
            asm.do_assembly(fsrc, None)
            asm.close_file(fsrc)
        #
        # Do the second pass with optional listing output
        #
        asm.set_pass(2)
        if params.lst is not None:
            flst = asm.open_file(params.lst, 'lst', 'w')
        else:
            flst = None
        for src in params.src:
            fsrc = asm.open_file(src, 'mic', 'r')
            asm.do_assembly(fsrc, flst)
            asm.close_file(fsrc)
        asm.final_stat(flst)
        asm.close_file(flst)
        #
        # Save the assembling results
        #
        if params.obj is not None and asm.ecnt == 0:
            fobj = asm.open_file(params.obj, 'mif', 'w')
            if params.ttl is None:
                asm.write_obj(fobj, 22)
            else:
                asm.write_obj(fobj, 18)
            asm.close_file(fobj)
        if params.ttl is not None and asm.ecnt == 0:
            fttl = asm.open_file(params.ttl, 'ttl', 'w')
            asm.write_ttl(fttl)
            asm.close_file(fttl)
        if asm.ecnt or asm.wcnt:
            sys.exit(1)
        sys.exit(0)

    except RuntimeError as err:
        print('\r\nerror: %s' % err, file=sys.stderr)
        sys.exit(1)


if __name__ == '__main__':
    main()
