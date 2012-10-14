#!/usr/bin/env ruby
#
# Convert a CBMXfer disassembly to ACME assembler syntax.  This was
# written to reassemble the Softbox code and only converts what
# was necessary for that program.
#
# ruby disasm2acme.rb inputfile.asm > outputfile.asm
#
filename = ARGV[0]
abort "Usage: disasm2acme <filename>" unless filename && File.exist?(filename)

File.readlines(filename).each do |line|
  line.strip!

  # Equate
  #   BLINK_CNT = $01  ;Counter used for cursor blink timing
  if line =~ /^[a-z]/i
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
    bytelist, comment = line.split(";",2)
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

  # Label
  #   :INIT_4080
  if line.start_with?(":")
    line = line.slice(1, line.length) + ":"

  # Whole line comment
  #   ;Detect 40/80 column screen and store in X_WIDTH
  elsif line.start_with?(";")
    # pass

  # Empty line
  elsif line.length == 0
    # pass

  # Instruction
  #   STA X_WIDTH  ;X_WIDTH = 40 characters
  else
    line.gsub! "ASL A", "ASL ;A"
    line.gsub! "LSR A", "LSR ;A"
    line.gsub! "ROR A", "ROR ;A"

    line = "    " + line
  end

  puts line
end
