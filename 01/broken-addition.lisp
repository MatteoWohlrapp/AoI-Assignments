; Hello Matteo, I hope this works :)
; This is the code we need to fix
; For now, I'll start fixing the more obvious things and acoment what I did.
; Later we can propperly comment on everyhting

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
 (six ISA number number six next seven) ;"seven" was "eight". I changed it
 (seven ISA number number seven next eight)
 (eight ISA number number eight next nine)
 (nine ISA number number nine next ten)
 (ten ISA number number ten)
 (test-goal ISA add arg1 zero arg2 zero))

 ; All "ISA" were in lower case for the numbers. I set them to upper case for clarity (lisp is not case sensitive)

 ;(goal-focus test-goal) I'm not sure we need to add this

(P initialize-addition 
   =goal>
      ISA         add            ; This line was just "add", without "ISA"
      arg1        =num1
      arg2        =num2
      sum         nil
  ==>
   =goal
      ISA         add
      sum         =num1
      count       zero
   +retrieval>
      ISA         number
      number      =num1 ; maybe this should be "num1"
)

(P terminate-addition
   =goal>
      ISA         add
      count       =num
      arg2        =num2 ; maybe this should be "num"
      sum         =answer ; "sum" was "summ"
  ==>
   =goal>
      ISA         add
      count       nil
)


(P increment-sum1 ; This and the following productions had the same name so I numbered them
   =goal>
      ISA         add
      sum         =sum
      count       =count
   =retrieval>
      ISA         number
      number      =sum
      next        =newcount
==>
   =goal>
      ISA         add
      count       =newcount
   +retrieval>
      ISA        number
      number     =sum
)

(P increment-sum2
   =goal>
      ISA         add
      sum         =sum
      count       =count
    - arg2        =count
   =retrieval>
      ISA         number
      next        =newsum
==>
   =goal>
      ISA         add
      sum         =newsum
   +retrieval>
      ISA         number
      number      =count
   
)

