---------------------------- MODULE Correctness ----------------------------
EXTENDS Naturals, CRDTInterface
-----------------------------------------------------------------------------
CONSTANTS Read(_)  \* Read(r \in Replica): the read operation at r 
    
UMsg == [aid : Aid, update: SUBSET Aid]  \* update message type   
-----------------------------------------------------------------------------
VARIABLES 
    doset,     \* doset[r]: the set of updates generated by replica r \in Replica
    delset,    \* delset[r]: the set of updates delivered by replica r \in Replica
    uincoming  \* uincoming[r]: incoming channel for broadcasting/delivering updates at r \in Replica
    
CTypeOK ==
    /\ doset \in [Replica -> SUBSET Aid]
    /\ delset \in [Replica -> SUBSET Aid]
    /\ uincoming \in [Replica -> SUBSET UMsg]
-----------------------------------------------------------------------------   
CInit == 
    /\ doset = [r \in Replica |->{}]
    /\ delset = [r \in Replica |-> {}]
    /\ uincoming = [r \in Replica |-> {}]
    
CDo(r) == 
    /\ doset' = [doset EXCEPT ![r] = @ \cup {[r |-> r, seq |-> seq[r]]}]
    /\ delset' = [delset EXCEPT ![r] = @ \cup {[r |-> r, seq |-> seq[r]]}]
    /\ UNCHANGED <<uincoming>>

CSend(r) ==  UNCHANGED <<delset, doset>>  \* implemented by OpCorrectness and StateCorrectness
           
CDeliver(r, aid) ==  \* choose the update message um according to aid
    /\ LET um == CHOOSE m \in uincoming[r] : m.aid = aid \* um is unique
       IN  delset' = [delset EXCEPT ![r] = @ \cup um.update] 
    /\ UNCHANGED <<uincoming, doset>>
-----------------------------------------------------------------------------   
SEC == \A r1, r2 \in Replica : delset[r1] = delset[r2] => Read(r1) = Read(r2)

EV == \A aid \in Aid, r \in Replica: aid \in doset[r] ~> (\A s \in Replica : aid \in delset[s])
=============================================================================
\* Modification History
\* Last modified Thu Aug 29 10:44:06 CST 2019 by xhdn
\* Created Wed Aug 28 16:48:45 CST 2019 by xhdn
