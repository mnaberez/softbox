#!/usr/bin/env ruby
#
# Convert a CBMXfer disassembly to ACME assembler syntax.  This was
# written to reassemble the SoftBox code and only converts what
# was necessary for that program.
#
# ruby disasm2acme.rb file.disasm > file.asm
#
filename = ARGV[0]
abort "Usage: disasm2acme <filename>" unless filename && File.exist?(filename)

File.readlines(filename).each do |line|
  # Indented comment line
  if line =~ /^ {12,};/
    puts line.slice(13, line.length)
    next
  end

  line.strip!

  # Label or equate
  #   INIT_4080:
  #   BLINK_CNT = $01  ;Counter used for cursor blink timing
  if line =~ /^[a-z]/i
    label, comment = line.split(";", 2)
    line = label.downcase
    line += ";#{comment}" if comment
    puts line
    next
  end

  # Add hexadecimal prefix to program counter directive
  #   *=0400
  if line.start_with?("*")
    asterisk, address = line.split("=", 2)
    line = "*=$" + address.sub(/^[\s$]+/, "")
  end

  # Strip disassembly address and bytes
  #   $049D: 85 09     STA X_WIDTH   ;X_WIDTH = 40 characters
  #   $0720:           .WORD CMD_01  ;Store #$FF in $13
  #   $0B3F:           .BYT AA,AA,AA,AA,AA,AA,AA,AA  ;Filler
  if line.start_with?("$")
    line = line.slice(17, line.length)
  end

  # Byte directive
  #   .BYT AA,AA,AA,AA,AA,AA,AA,AA  ;Filler
  if line.start_with?(".BYT")
    bytelist, comment = line.split(";", 2)
    line = "!byte " +
      bytelist.scan(/([\dA-F]{2})/).flatten.map{|b| "$" + b}.join(",")
    line += " ; #{comment}" if comment
  end

  # Word directive
  #   .WORD CMD_01  ;Store #$FF in $13
  if line.start_with?(".WORD")
    wordlist, comment = line.split(";", 2)
    line = "!word " + wordlist.gsub(".WORD ", "")
    line += " ; #{comment}" if comment
  end

  # Whole line comment without indent
  #   ;Detect 40/80 column screen and store in X_WIDTH
  if line.start_with?(";")
    # pass

  # Empty line
  elsif line.length == 0
    # pass

  # Instruction
  #   STA X_WIDTH  ;X_WIDTH = 40 characters
  else
    line.gsub! /ASL A ?/, "asl ;a"
    line.gsub! /LSR A ?/, "lsr ;a"
    line.gsub! /ROL A ?/, "rol ;a"
    line.gsub! /ROR A ?/, "ror ;a"

    instruct, comment = line.split(";", 2)
    line = "    " + instruct.downcase
    line += ";#{comment}" if comment
  end

  puts line
end
