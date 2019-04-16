---- MODULE MC ----
EXTENDS RGA, TLC

\* MV CONSTANT declarations@modelParameterConstants
CONSTANTS
r1, r2, r3
----

\* MV CONSTANT definitions Replica
const_1555421094280178000 == 
{r1, r2, r3}
----

\* SYMMETRY definition
symm_1555421094280179000 == 
Permutations(const_1555421094280178000)
----

\* CONSTANT definitions @modelParameterConstants:0Charnum
const_1555421094280180000 == 
5
----

\* CONSTANT definitions @modelParameterConstants:1Char
const_1555421094280181000 == 
{"a" ,"b" ,"c" ,"d" ,"e"}
----

\* CONSTANT definition @modelParameterDefinitions:0
CONSTANT def_ov_1555421094280182000
----
\* CONSTANT definition @modelParameterDefinitions:1
def_ov_1555421094280183000 ==
1..10
----
=============================================================================
\* Modification History
\* Created Tue Apr 16 21:24:54 CST 2019 by jywellin