---- MODULE MC ----
EXTENDS RGA, TLC

\* MV CONSTANT declarations@modelParameterConstants
CONSTANTS
r1, r2, r3
----

\* MV CONSTANT definitions Replica
const_1555425027998267000 == 
{r1, r2, r3}
----

\* SYMMETRY definition
symm_1555425027998268000 == 
Permutations(const_1555425027998267000)
----

\* CONSTANT definitions @modelParameterConstants:0Charnum
const_1555425027998269000 == 
10
----

\* CONSTANT definitions @modelParameterConstants:1Char
const_1555425027998270000 == 
{"a" ,"b" ,"c" ,"d" ,"e","1","2","3","4","5"}
----

\* CONSTANT definition @modelParameterDefinitions:0
CONSTANT def_ov_1555425027998271000
----
\* CONSTANT definition @modelParameterDefinitions:1
def_ov_1555425027998272000 ==
1..10
----
=============================================================================
\* Modification History
\* Created Tue Apr 16 22:30:27 CST 2019 by jywellin