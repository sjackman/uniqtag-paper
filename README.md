UniqTag: Assign unique, stable, content-derived identifiers to genes
====================================================================

Shaun Jackman, Joerg Bohlmann, İnanç Birol

Abstract
========

Summary
-------

UniqTag assign unique identifiers to sequences of characters, such as
gene sequences, that are derived from the *k*-mer composition of the
gene sequence.

Availability and implementation
-------------------------------

The implementation of UniqTag is available at
`https://github.com/sjackman/uniqtag`

Contact
-------

Shaun Jackman &lt;sjackman@gmail.com&gt;

Introduction
============

Annotating genes, the process of identifying regions of a genome that
code for genes, typically follows genome sequence assembly. These
genes are assigned unique identifiers by which they can be referenced.
Assembly is often an iterative process, refining the method to produce
better assemblies, or the addition of the new sequencing data. Ideally
these gene identifiers would be reasonably stable from one assembly to
the next. Genes are typically assigned serial numbers, which, although
certainly unique, are not at all stable between assemblies. One small
change in the assembly can result in a totally renumber of the
annotated genes.

One solution is to assign identifiers based on the content of the gene
sequence, rather than its position in the assembly. A cryptographic
hash function such as SHA (secure hash algorithm) [cite] derives a
message digest from the sequence, such that two sequences with the
same content will have the same message digest, and any two sequences
with different content will have different message digests. When a
message digest is used to identify a gene, the same gene in two
assemblies with identical content will be assigned identical
identifiers, but, by the design of a cryptographic hash function, even
a slight change in the sequence, such as a single-character
substitution, will result in a totally new digest and identifier.

A cryptographic hash function is design so that every bit of the
message digest has even odds of being flipped after a single bit
change of the message, called the avalanche effect [cite]. In
contrast, locality-sensitive hashing (LSH) [cite] aims to assign
identical message digests to messages with similar content. A hash
function that, after a small perturbation of the sequence, assigns
the same identifier to the sequence is desirable for identifying the
genes of a genome sequence assembly project. One such
locality-sensitive hash function, MinHash [cite], is often employed in
identifying web pages with similar content. UniqTag is inspired by
MinHash to assign stable identifiers to genes.

Algorithm
=========

The following symbols are defined.

+ *Σ* is an alphabet
+ *s* is a string, a sequence of symbols from the alphabet *Σ*
+ *S* is a set of strings
+ $Σ^k$ is the set of all strings over *Σ* of length *k*
+ $C(s)$ is the set of all substrings of *s*
+ A *k*-mer of *s* is a substring of *s* with length *k*, also called
  an *n*-gram
+ $C_k(s)$ is the set of all *k*-mers present in *s*
+ $\min S$ is the lexicographically smallest string in *S*
+ $f(s, S)$ is the frequency of *s* in *S*, defined as the number of
  strings in *S* that contain *s* as a substring
+ $\min f_k(s, S)$ is the frequency of the least frequent *k*-mer in *S*
+ $u_k(s, S)$ the lexicographically smallest *k*-mer of the *k*-mers
  of *s* that are least frequent in *S*

The UniqTag $u_k(s, S)$ is defined as follows.

$$
\begin{eqnarray}
C_k(s) &=& C(s) ∩ Σ^k
\\ f(s, S) &=& \left\vert \{ t \mid s ∈ C(t) ∧ t ∈ S \} \right\vert
\\ \min f_k(s, S) &=& \min \{ f(t, S) \mid t ∈ C_k(s) \}
\\ u_k(s, S) &=& \min \{ t \mid t ∈ C_k(s) ∧ f(t, S) = \min f_k(s, S) \}
\end{eqnarray}
$$

Discussion
==========

When iterating over multiple assemblies of the same data, it is rather
inconvenient for gene identifiers to change completely from one
assembly to the next. The gene identifier scheme described here
attempts to address this common annoyance. By identifying the gene
using the lexicographically smallest *k*-mer in the gene, the gene
identifier is reasonably stable across assemblies.

A UniqueTag will change due to either a difference in the locus of the
UniqueTag itself, or a difference that results in the creation of a
unique *k*-mer that is lexicographically smaller than the previous
UniqueTag. Concatenating two gene models results in a gene whose
UniqueTag is the minimum of the two previous UniqueTags, unless by
chance one of the k-mer at the junction of the two sequences is
lexicographically smaller.

A UniqueTag can be generated from the nucleotide sequence of a gene.
Using however the translated amino acid sequence of a protein-coding
gene sequence results in a UniqueTag that is stable across synonymous
changes to the coding sequence, and changes to the untranslated
regions of the gene, including UTRs and introns. Additionally, fewer
characters are necessary for a *k*-mer to be unique, resulting in a
shorter gene identifier.

Two gene models that have identical coding sequence have the same
UniqueTag. It is possible that two genes with different sequence that
have no unique *k*-mer will be assigned the same UniqueTag. This
situation is most common for very short sequences. Genes that are
assigned the same UniqueTag are distinguished by adding a numerical
suffix to the UniqueTag.

Acknowledgements
================

Thanks to Nathaniel Street for his enthusiastic feedback, to the
SMarTForests project, its funders and the organizers of the 2014
Conifer Genome Summit that made our conversation possible.

Funding
=======

This work was supported by the Natural Sciences and Engineering
Research Council of Canada, Genome British Columbia, Genome Alberta,
Genome Québec and Genome Canada.

References
==========

+ Avalanche effect - Feistel, Horst (1973). "Cryptography and Computer Privacy". Scientific American 228 (5).
+ SHA (secure hash algorithm)
+ Locality-sensitive hashing
+ MinHash
