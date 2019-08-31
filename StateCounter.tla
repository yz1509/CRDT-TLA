---------------------------- MODULE StateCounter ----------------------------
EXTENDS Counter
CONSTANTS Read(_), InitMsg
-----------------------------------------------------------------------------
VARIABLES
    state,     \* state[r]: the state of r \in Replica
    (* variables for network: *) 
    incoming,  \* incoming[r]: incoming channel at replica r \in Replica
    lmsg,      \* lmsg[r]: the last message delivered at r \in Replica to the upper-layer protocol 
    (* variables for Correctness: *) 
    doset,     \* doset[r]: the set of updates generated by replica r \in Replica
    delset,    \* delset[r]: the set of updates delivered by replica r \in Replica
    uincoming  \* uincoming[r]: incoming channel for broadcasting/delivering updates at r \in Replica
    
nVars  == <<incoming, lmsg>>
cVars == <<doset, delset, uincoming>> 
vars == <<state, seq, nVars, cVars>>
-----------------------------------------------------------------------------  
Msg == [aid : Aid, rstate : [Replica -> Nat] ]  
Network == INSTANCE BasicNetwork  \* WITH incoming <- incoming, lmsg <- lmsg     
                              
Max(a, b) == IF a > b THEN a ELSE b

ReadStateCounter(r) == state[r]  \* read the state of r\in Replica
Correctness == INSTANCE StateCorrectness  \* WITH doset <- doset, delset <- delset, uincoming <- uincoming                                         
----------------------------------------------------------------------------    
TypeOK ==
    /\state \in [Replica -> [Replica -> Nat]]
    /\IntTypeOK
    /\Correctness!CTypeOK
-----------------------------------------------------------------------------
Init == 
    /\ state = [r \in Replica |-> [s \in Replica |-> 0]]
    /\ IntInit  
    /\ Network!BNInit
    /\ Correctness!CInit
-----------------------------------------------------------------------------              
Inc(r) ==  
    /\ state' = [state EXCEPT ![r][r] = @ + 1]
    /\ IntDo(r)
    /\ Correctness!CDo(r)
    /\ UNCHANGED <<nVars>>
                         
Do(r) ==  Inc(r)\* We ignore ReadStateCounter(r) since it does not modify states.       
-----------------------------------------------------------------------------
Send(r) ==  \* r\in Replica sends a message 
    /\ Network!BNBroadcast(r, [aid |-> [r |-> r, seq |-> seq[r]], rstate |-> state[r]])  
    /\ IntSend(r)
    /\ Correctness!CSend(r) 
    /\ UNCHANGED <<state>>
           
Deliver(r) ==  \* r\in Replica delivers a message (lmsg'[r]) 
    /\ IntDeliver(r)
    /\ Network!BNDeliver(r)
    /\ Correctness!CDeliver(r, lmsg'[r].aid)
    /\ \A s \in Replica : state' = [state EXCEPT ![r][s] = Max(@, lmsg'[r].rstate[s])]    
    /\ UNCHANGED <<>> 
-----------------------------------------------------------------------------
Next == \E r \in Replica: Do(r) \/ Send(r) \/ Deliver(r)

Fairness == \A r \in Replica: WF_vars(Send(r)) /\ WF_vars(Deliver(r))

Spec == Init /\ [][Next]_vars /\ Fairness
=============================================================================
\* Modification History
\* Last modified Sat Aug 31 20:36:11 CST 2019 by xhdn
\* Created Thu Jul 25 16:38:48 CST 2019 by jywellin
