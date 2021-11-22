(clear-all)

(define-model tutor-model
    
(sgp :esc t :lf .05 :trace-detail medium)


;; Add Chunk-types here
(chunk-type addition-fact addend1 addend2 sum)
(chunk-type add-pair one1 ten1 one2 ten2 one-ans ten-ans carry)

;; Add Chunks here
(add-dm
 (fact34 ISA addition-fact addend1 3 addend2 4 sum 7)
 (fact67 ISA addition-fact addend1 6 addend2 7 sum 13)
 (fact103 ISA addition-fact addend1 10 addend2 3 sum 13)
 (fact17 ISA addition-fact addend1 1 addend2 7 sum 8)

 (goal ISA add-pair one1 6 ten1 3 one2 7 ten2 4))

;; Add productions here
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
; how to check if error occured? 
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