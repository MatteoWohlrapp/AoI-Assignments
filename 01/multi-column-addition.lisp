(clear-all)

(define-model tutor-model
    
(sgp :esc t :lf .05 :trace-detail medium)


;; Add Chunk-types here
(chunk-type addition-fact addend1 addend2 sum)
(chunk-type add-pair one1 ten1 one2 ten2 one-ans ten-ans carry)

;; Add Chunks here
(add-dm
 (fact47 ISA addition-fact addend1 4 addend2 7 sum 11)
 (fact25 ISA addition-fact addend1 2 addend2 5 sum 7)
 (fact17 ISA addition-fact addend1 1 addend2 7 sum 8)
 (fact101 ISA addition-fact addend1 10 addend2 1 sum 11)
 (goal ISA add-pair ten1 2 one1 4 ten2 5 one2 7 ))

;; Add productions here
; production to start the addition, gets selected if the field one-ans is not calculated yet
; only happens at the beginning, since we start the calculation by adding the ones of the numbers 
; creates a request to the retrieval module to find a chunk with the ones as addents
(P start-pair
    =goal> 
        ISA         add-pair
        one1        =num1
        one2        =num2 
        one-ans     nil 
   ==> 
    =goal> 
        one-ans     busy
    +retrieval> 
        ISA         addition-fact 
        addend1     =num1 
        addend2     =num2 
)

; production to add the ones, selected when the one-ans is set to busy. 
; uses the addition-fact which was asked for in the start-pair
; also, the calculation of the carry is started, with a request to the retrieval module
(P add-ones 
    =goal> 
        ISA         add-pair
        one-ans     busy 
        one1        =num1 
        one2        =num2 
    =retrieval> 
        ISA         addition-fact 
        addend1     =num1 
        addend2     =num2
        sum         =num3
   ==> 
    =goal> 
        one-ans     =num3 
        carry       busy 
    +retrieval> 
        ISA         addition-fact 
        addend1     10 
        sum         =num3 
)

; production to process the carry. Idea is to check if the added ones are bigger than 10 + number 
; carry is then set to one
(P process-carry
    =goal> 
        ISA         add-pair 
        carry       busy
        one-ans     =num1
        ten1        =num2 
        ten2        =num3
    =retrieval> 
        ISA         addition-fact
        addend1     10 
        addend2     =num4
        sum         =num1 
   ==> 
    =goal> 
        carry       1 
        one-ans     =num4
        ten-ans     busy 
    +retrieval> 
        ISA         addition-fact 
        addend1     =num2 
        addend2     =num3
)

; production selected if there is no carry. That happens if there is a buffer failure in the retriveal buffer
; happens because there is no chunk which holds information about the ones being bigger or equal to 10
(P no-carry
    =goal> 
        ISA         add-pair 
        carry       busy
        ten1        =num1
        ten2        =num2
    ?retrieval>
        buffer failure
   ==> 
    =goal> 
        carry       nil  
        ten-ans     busy 
    +retrieval> 
        ISA         addition-fact
        addend1     =num1 
        addend2     =num2
) 

; last production, is selected if there is no carry to add. Takes the before requested sum
; from the retrieval buffer and put it into the goal buffer
(P add-tens-done
    =goal> 
        ISA         add-pair 
        ten-ans     busy 
        carry       nil
    =retrieval> 
        ISA         addition-fact 
        sum         =num1
   ==> 
    =goal> 
        ten-ans     =num1
)

; production for adding the tens if there is a carry. 
; function takes the solution of the added tens and creates a request for the retrieval buffer for the sum + 1
; this way the carry is added to the solution. The carry is then set to nil
(P add-tens-carry
    =goal> 
        ISA         add-pair  
        ten-ans     busy 
        carry       1
    =retrieval> 
        ISA         addition-fact 
        sum         =num1  
   ==> 
    =goal> 
        carry       nil  
    +retrieval> 
        ISA         addition-fact 
        addend1     1
        addend2     =num1
) 

(goal-focus goal)
)