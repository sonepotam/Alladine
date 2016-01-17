CREATE GLOBAL TEMPORARY TABLE  bp_all_GTT(
  Account   varChar2( 32),
  Operation varChar2( 10),
  SummaType varChar2( 10),
  nOrder    number)
  on commit delete rows;
