
(clear-all)

(define-model addition

(sgp :esc t :lf .05)

(chunk-type number number next)
(chunk-type add arg1 arg2 sum count)

(add-dm
 (zero ISA number number zero next one)
 (one ISA number number one next two)
 (two ISA number number two next three)
 (three ISA number number three next four)
 (four ISA number number four next five)
 (five ISA number number five next six)
 ; changed "eight" to "seven"
 (six ISA number number six next seven)
 (seven ISA number number seven next eight)
 (eight ISA number number eight next nine)
 (nine ISA number number nine next ten)
 (ten ISA number number ten)
 (test-goal ISA add arg1 one arg2 one))

; All "ISA" were in lower case, changed for clarity even though lisp is not case sensitive


(P initialize-addition 
   =goal>
   ; added 'ISA' to the line
      ISA         add          
      arg1        =num1
      arg2        =num2
      sum         nil
  ==>
  ; added '>'
   =goal>
      ISA         add
      sum         =num1
      count       zero
   +retrieval>
      ISA         number 
      number      =num1 
)

(P terminate-addition
   =goal>
      ISA         add
      count       =num
      ; change variable to num, so arg2 matches num 
      arg2        =num 
      ; typo: summ -> sum
      sum         =answer
   ; added condition for retrieval buffer to check if answers match
   =retrieval>
      ISA         number
      number      =answer
  ==>
   =goal>
      ISA         add
      count       nil
)

; changed name since not the sum gets incremented but the count
(P increment-count 
   =goal>
      ISA         add
      sum         =sum
      count       =count
   =retrieval>
      ISA         number
      ; changed sum to count, so the two variables match. Necessary since we are increamenting count 
      number      =count
      next        =newcount
  ==>
   =goal>
      ISA         add
      count       =newcount
   +retrieval>
      ISA        number
      number     =sum
)

(P increment-sum
   =goal>
      ISA         add
      sum         =sum
      count       =count
    - arg2        =count
   =retrieval>
      ISA         number
      ; added: necessary to see if the number in the retrieval buffer actually matches the sum 
      number      =sum 
      next        =newsum
==>
   =goal>
      ISA         add
      sum         =newsum
   +retrieval>
      ISA         number
      number      =count
   
)

 (goal-focus test-goal)
)