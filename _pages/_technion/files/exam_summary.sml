(*	Programing Langauges - Exam Help Page
	=========================================================
    = Summary of functions that appears in the tutorial 	=
    =														=
	= sartium@t2											=
	= Winter 2010											=
    = V 1.1													=
    =========================================================
*)

"Standard" ^ " ML";		(* string concatination *)
#"0";					(* char*)
str(#"0");				(* char to string *)
String.sub("hello",0);	(* substring *)
ord #"0";				(* Convert char to ASCII *)
(*
val it = "Standard ML" : string
val it = #"0" : char
val it = "0" : string
val it = #"h" : char
val it = 48 : int
*)

("str",1,true,(#"0",0.1)); (* Tuples *)
#1 it;					(* Selecting elements in a tuple *)
val me = { name="Ofir", age=30 }; (* Records *)
#age(me);				(* Selecting a field in a record *)
(*
val it = ("str",1,true,(#"0",0.1)) : string * int * bool * (char * real)
val it = "str" : string
val me = {age=30,name="Ofir"} : {age:int, name:string}
val it = 30 : int
val it = () : unit
*)

fun gcd(m,n) =
		if m=0 then n 
        else gcd(n mod m, m);
gcd(42,126);
(*
val gcd = fn : int * int -> int
val it = 42 : int
*)

(*fun d(x,y) = Math.sqrt(x*x+y*y);
d;
d(1.0,3.0);
infix d;
1.0 d 3.0;*)
(* d; *) 				(* Error *)
(*op d;
op d(1.0, 3.0);*)
(*
val d = fn : real * real -> real
val it = fn : real * real -> real
val it = 3.16227766017 : real
infix d
val it = 3.16227766017 : real
val it = fn : real * real -> real
val it = 3.16227766017 : real
val it = () : unit
*)

infix o;
fun (f o g) x = f (g x);(* Function composition *)	
fun times n m = 		(* Recursive curried function *)
			if m=0 then 0
			else n + times n (m-1);
(*
infix o
val o = fn : ('a -> 'b) * ('c -> 'a) -> 'c -> 'b
val times = fn : int -> int -> int
*)            

val rec f = fn (n) => 	(* Recursive definition using val rec *)
				if n=0 then 1
				else n * f(n-1);

fun factorial 0 = 1		(* Pattern matching *)
  | factorial n = n * factorial(n-1);

case 2 of				(* Case *)
    0 => "zero"
  | 1 => "one"
  | 2 => "two"
  | n => if n<10 then "lots"
         else "lots &lots";
(*
val f = fn : int -> int
val factorial = fn : int -> int
val it = "two" : string
*)

fun fraction(n,d1)=
	let val com = gcd(n,d1)
in (n div com, d1 div com) end;

local
	fun itfib (p,prev,curr):int=
		if p=1 then curr
		else itfib (p-1,curr,prev+curr)
	in
fun fib (n) = 
 	itfib(n,0,1)
end;
(*
val fraction = fn : int * int -> int * int
val fib = fn : int -> int
*)

(*
var x:=0; y:=0; z:=0;
F: x:=x+1; goto G
G: if y<z then goto F else (y:=x+y; goto H)
H: if z>0 then (z:=z-x; goto F) else stop
*)
fun F(x,y,z)=G(x+1,y,z)
and G(x,y,z)=if y<z then F(x,y,z) else H(x,x+y,z)
and H(x,y,z)=if z>0 then F(x,y,z-x) else (x,y,z);
F(0,0,0);
(*
val F = fn : int * int * int -> int * int * int
val G = fn : int * int * int -> int * int * int
val H = fn : int * int * int -> int * int * int
val it = (1,1,0) : int * int * int
*)

1::2::3::4::nil;
1::[2,3,4];
["Append","is"] @ ["never","boring"];
fun null [] = true
  | null (_::_) = false;
fun hd (x::_) = x; 
fun tl (_::xs) = xs;
fun upto (m,n) = if m>n then [] 
				 else m :: upto(m+1,n);
fun take ([],i) = []	(* First i elements of the list *)
  | take (x::xs,i) =
  		if i>0 then x :: take(xs,i-1)
		else [];
fun map f [] = []		(* Apply a function to each element *)
  | map f (x::xs) = (f x) :: map f xs;      
fun transp ([]::_) = [] (* Transpose a matrix using map *)
  | transp rows =
		map hd rows :: transp (map tl rows);
fun filter pred [] = []
  | filter pred (x::xs) =
  		if pred(x) then x :: filter pred xs
		else filter pred xs;
fun insort le [] = []
  | insort le (x::xs) =
  		let fun ins(z,[]) = [z]
		      | ins(z,y::ys) =
                    if le(z,y) then z::y::ys
                    else y::ins(z,ys)
in
	ins(x, insort le xs)
end;
(*
val it = [1,2,3,4] : int list
val it = [1,2,3,4] : int list
val it = ["Append","is","never","boring"] : string list
val null = fn : 'a list -> bool
C:\exam_summary.sml:133.5-133.18 Warning: match nonexhaustive
          x :: _ => ...
  
val hd = fn : 'a list -> 'a
C:\exam_summary.sml:134.5-134.20 Warning: match nonexhaustive
          _ :: xs => ...
  
val tl = fn : 'a list -> 'a list
val upto = fn : int * int -> int list
val take = fn : 'a list * int -> 'a list
val map = fn : ('a -> 'b) -> 'a list -> 'b list
val transp = fn : 'a list list -> 'a list list
val filter = fn : ('a -> bool) -> 'a list -> 'a list
val insort = fn : ('a * 'a -> bool) -> 'a list -> 'a list
*) 

(* Sets *)
infix mem;
fun x mem [] = false
  | x mem (y::l) = (x=y) orelse (x mem l); 
fun newmem(x,xs) = 
		if x mem xs then xs
		else x::xs;
fun setof []     = []
  | setof(x::xs) = newmem(x,setof xs);
fun union([],ys)    = ys
  | union(x::xs,ys) = newmem(x,union(xs,ys));
fun inter([],ys) = []
  | inter(x::xs,ys) = if x mem ys
			then x::inter(xs,ys)
			else inter(xs,ys);
(*
infix mem
C:\exam_summary.sml:182.22 Warning: calling polyEqual
val mem = fn : ''a * ''a list -> bool
val newmem = fn : ''a * ''a list -> ''a list
val setof = fn : ''a list -> ''a list
val union = fn : ''a list * ''a list -> ''a list
val inter = fn : ''a list * ''a list -> ''a list
*)

fun exists pred [] = false
  | exists pred (x::xs) =
		(pred x) orelse exists pred xs;
fun forall pred [] = true
  | forall pred (x::xs) =
		(pred x) andalso forall pred xs;
(*
val exists = fn : ('a -> bool) -> 'a list -> bool
val forall = fn : ('a -> bool) -> 'a list -> bool
*)

datatype drink =
	Water
  | Coffee of string*int*bool
  | Wine of string
  | Beer of string;
val drinks = [Water, Coffee ("Elite",2,true), Beer "Paulaner"];
(*
datatype drink
  = Beer of string | Coffee of string * int * bool | Water | Wine of string
val drinks = [Water,Coffee ("Elite",2,true),Beer "Paulaner"] : drink list
*)

datatype ('a,'b)union = type1 of 'a
					  | type2 of 'b;
fun concat1 [] = ""
  | concat1 ((type1 s)::l) = s ^ concat1 l
  | concat1 ((type2 _)::l) = concat1 l;
(*
datatype ('a,'b) union = type1 of 'a | type2 of 'b
val concat1 = fn : (string,'a) union list -> string
*)

datatype 'a tree =
	Lf
  | Br of 'a * 'a tree * 'a tree;

val tree2 = Br(2,Br(1,Lf,Lf),Br(3,Lf,Lf));
exception Bsearch of string;
fun blookup(Br((a,x),t1,t2), b) =
		if b<a then blookup(t1,b)
		else if a<b then blookup(t2,b)
		else x
  | blookup(Lf,b) =
		raise Bsearch("lookup: "^Int.toString(b));     
fun binsert(Lf, b, y) = Br((b,y), Lf, Lf)
  | binsert(Br((a,x),t1,t2),b,y) =
		if b<a 
        	then Br((a,x),binsert(t1,b,y),t2)
		else if a<b 
        	then Br((a,x),t1,binsert(t2,b,y))
		else (*a=b*)
			raise Bsearch("insert: "^Int.toString(b));  
(*
datatype 'a tree = Br of 'a * 'a tree * 'a tree | Lf
val tree2 = Br (2,Br (1,Lf,Lf),Br (3,Lf,Lf)) : int tree
exception Bsearch of string
val blookup = fn : (int * 'a) tree * int -> 'a
val binsert = fn : (int * 'a) tree * int * 'a -> (int * 'a) tree
*)

exception Problem of int * int;
(* f(raise(Badvalue(raise Failure))) *) (* This is equivalent to raise Failure *)
exception Nth;
fun nth(x::_ ,0) = x
  | nth(x::xs,n) = if n>0 
  		then nth(xs,n-1)
		else raise Nth
  | nth _ = raise Nth;
fun sumchain (l,f,i) =
	nth(l,i)+sumchain(l,f,f(i)) handle Nth => 0;
(*
exception Problem of int
exception Nth
val nth = fn : 'a list * int -> 'a
val sumchain = fn : int list * (int -> int) * int -> int
*)
(*
show (methodA(problem) handle Failure => methodB(problem))
		handle Failure => "Both failed"
             | Impossible => "No Good"
*)
(*
Standard Exceptions

Chr is raised by chr(k) if k<0 or k>255
Match is raised for failure of pattern-matching (e.g.
	when an argument matchs none of the
	function’s patterns, if a case expression has no
	pattern that matches, etc.)
Bind is raised if the value of E does not match
	pattern P in the declaration val P = E
*)

datatype 'a seq = Nil
				| Cons of 'a * (unit-> 'a seq);                
fun head(Cons(x,_)) = x;
fun tail(Cons(_,xf)) = xf();
(* Add two sequences *)
fun addq (Cons(x,xf), Cons(y,yf))=
			Cons(x+y, fn()=>addq(xf(),yf()))
  | addq _ : int seq = Nil;
(* Append sequences *)
fun appendq (Nil, yq) = yq
  | appendq (Cons(x,xf), yq) =
  			Cons(x,fn()=>appendq(xf(),yq));
(* Inteleave sequences *)
fun interleaving (Nil, yq) = yq
  | interleaving (Cons(x,xf),yq) =
			Cons(x, fn()=>interleaving(yq,xf())); 
fun mapq f Nil = Nil
  | mapq f (Cons(x,xf)) =
		Cons( f(x), fn()=>mapq f (xf()) );
fun filterq pred Nil = Nil
  | filterq pred (Cons(x,xf)) =
		if pred x 
        	then Cons(x,fn()=>filterq pred (xf()))
   			else filterq pred (xf());        
(*
datatype 'a seq = Cons of 'a * (unit -> 'a seq) | Nil
C:\exam_summary.sml:301.5-301.24 Warning: match nonexhaustive
          Cons (x,_) => ...
  
val head = fn : 'a seq -> 'a
C:\exam_summary.sml:302.5-302.28 Warning: match nonexhaustive
          Cons (_,xf) => ...
  
val tail = fn : 'a seq -> 'a seq
val addq = fn : int seq * int seq -> int seq
val appendq = fn : 'a seq * 'a seq -> 'a seq
val interleaving = fn : 'a seq * 'a seq -> 'a seq
val mapq = fn : ('a -> 'b) -> 'a seq -> 'b seq
val filterq = fn : ('a -> bool) -> 'a seq -> 'a seq
*)

(* Prime Numbers Sequence *)
fun from k = Cons(k,fn()=>from(k+1));
fun notDivide p = filterq (fn n => n mod p <> 0);
fun sieve (Cons(p,nf)) =
		Cons(p, fn () => sieve(notDivide p (nf())));
val primes = sieve (from 2);
head (tail (tail primes));
(*
val from = fn : int -> int seq
val notDivide = fn : int -> int seq -> int seq
C:\exam_summary.sml:343.5-344.46 Warning: match nonexhaustive
          Cons (p,nf) => ...
  
val sieve = fn : int seq -> int seq
val primes = Cons (2,fn) : int seq
val it = 5 : int
*)