#!/usr/bin/perl
# Lists sentences that end ", <short phrase>." in book Markdown:  the stacked
# tail, WRITING_COMMON_ERRORS.md entry 27.  Added 2026-11-01, when Jason
# found many of them proofreading.  check_prose.sh runs it.
#
#     perl lessons/chapters/tools/comma_tails.pl [maxwords] file.md ...
#
# A hit is a sentence to reread, not a verdict:  delete the tail, and keep it
# only if a fact went with it.  [BARE] tails are the ones to read;  [coord]
# (", and ...") and [example] (", like ...") rarely need anything.
# Prose only:  code fences, tables, headings skipped.  Paragraphs are joined
# across wrapped lines (box "> " prefixes stripped), then split into sentences.
# Each hit:  file:line  [kind]  tail  ||  sentence
use strict; use warnings;
my $max = ($ARGV[0] =~ /^\d+$/) ? shift : 5;
for my $f (@ARGV) {
  open my $h, '<:encoding(UTF-8)', $f or die "$f: $!";
  my @lines = <$h>; close $h;
  my ($fenced, @para, $start) = (0);
  my $flush = sub {
    return unless @para;
    my $text = join ' ', @para; @para = ();
    $text =~ s/`[^`]*`/CODE/g;
    $text =~ s/\s+/ /g;
    # sentences end at . ? ! followed by space+capital/quote/end
    my @s = split /(?<=[.?!]["'*)]?)\s+(?=["*(A-Z`]|$)/, $text;
    for my $s (@s) {
      next unless $s =~ /,\s*([^,]+?)[.!?]["'*)]*\s*$/;
      my $tail = $1;
      my @w = split ' ', $tail;
      next if @w > $max;
      my $kind = $tail =~ /^(and|or|but|so|nor)\b/i ? 'coord'
               : $tail =~ /^(like|such as|including|e\.g)\b/i ? 'example'
               : 'BARE';
      binmode STDOUT, ':encoding(UTF-8)';
      print "$f:$start  [$kind]  $tail  ||  $s\n";
    }
  };
  for my $i (0..$#lines) {
    my $l = $lines[$i]; $l =~ s/\r?\n$//;
    my $body = $l; $body =~ s/^(>\s?)+//;
    if ($body =~ /^```/) { $fenced = !$fenced; $flush->(); next }
    next if $fenced;
    if ($body =~ /^\s*$/ || $body =~ /^(#|\||---|<!--)/ ) { $flush->(); next }
    if ($body =~ /^(\s*[-*]|\s*\d+\.)\s/) { $flush->(); }
    $start = $i + 1 unless @para;
    push @para, $body;
  }
  $flush->();
}
