with Ada.Integer_Text_Io; use Ada.Integer_Text_Io;
with Ada.Text_Io; use Ada.Text_Io;
with Ada.Unchecked_Deallocation;
with file_priorite;
-- Exemple de lecture/ecriture de donnes dans un fichier,
-- a l'aide de flux Ada.

with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
package body Huffman is

  type Noeud is record
    valeur: Character;
    occurence:Integer;
    filsgauche: Arbre;
    filsdroit : Arbre;
  end record;

  type cellule is record
    Data: Character;
    Prio: Integer;
  end record;

  procedure Free is new Ada.Unchecked_Deallocation (Noeud,Arbre);

  package File_Priorite_Arbre_Huffman is
    new File_Priorite(Arbre_Huffman,Integer,"=","<");
    use File_Priorite_Arbre_Huffman;

    type Octet is new Integer range 0 .. 255;
    for Octet'Size use 8; -- permet d'utiliser Octet'Input et Octet'Output,
    -- pour lire/ecrire un octet dans un flux


    function creer_arbre(C: Character;i: Integer) return Arbre is       --Cree un Arbre
      A:Arbre:=new Noeud;
    begin
      A.valeur:=C;
      A.occurence:=i;
      A.filsgauche:=NULL;
      A.filsdroit:=NULL;
      return A;
    end creer_arbre;


    procedure Libere_Arbre(A : in out Arbre) is       -- libere l'Arbre
    begin
      if (A.filsgauche/=NULL) then
        Libere_Arbre(A.filsgauche);
      end if;
      if (A.filsdroit/=NULL) then
        Libere_Arbre(A.filsdroit);
      end if;
      free(A);
    end Libere_Arbre;

    procedure Libere(H: in out Arbre_Huffman) is
    begin
      Libere_Arbre(H.A);
    end Libere;

    procedure Affiche_Arbre(A:in Arbre) is      -- fonction recursive pour parcourir l'arbre Affiche a juste à l'appeler;
    begin
      if A.filsdroit/=NULL then
        Affiche_Arbre(A.filsdroit);
      end if;
      if A.filsgauche/=NULL then
        Affiche_Arbre(A.filsgauche);
      end if;
      if A.filsgauche=NULL and A.filsdroit=NULL then
        Put(A.valeur);
        Put(Integer'Image(A.occurence));
      end if ;
    end Affiche_Arbre;


    procedure Affiche(H:in Arbre_Huffman) is

    begin
      Put_Line("");
      Affiche_Arbre(H.A);
      Put_Line("");
    end Affiche;


    -- Lit dans un fichier ouvert en lecture, et affiche les valeurs lues

    procedure Fusion_Arbre(moins_prio1: in out Arbre_Huffman;moins_prio2: in Arbre_Huffman) is -- permet de créer l'arbre composé des deux branches d'ordre de priorité connu
      A:Arbre:=new Noeud;

    begin
      A.filsdroit:=moins_prio1.A;
      A.filsgauche:=moins_prio2.A;
      moins_prio1.Nb_Total_Caracteres:=moins_prio2.Nb_Total_Caracteres+moins_prio1.Nb_Total_Caracteres; -- on met à jour le poids de ce nouvel arbre_hoffmann
      moins_prio1.A:=A;
    end Fusion_Arbre;




    function Cree_Huffman(Nom_Fichier : in String) return Arbre_Huffman is
      Fichier : Ada.Streams.Stream_IO.File_Type;
      Flux : Ada.Streams.Stream_IO.Stream_Access;
      C : Character;
      T : array(0..256) of cellule; -- ce tableau sert à faire un premier enregistrement des characters présents dans le fichier
      F:File_Prio:=Cree_File(256);    --  file priorite
      Huffman: Arbre_Huffman;
      moins_prio1 : Arbre_Huffman;
      moins_prio2 : Arbre_Huffman;          -- elements intermediaires pour la fusion
      prio1 : Integer;      --elements facilitants la fusion avec l'utilisations de fonctions de file_priorite
      prio2: Integer;
    begin
      for j in 0..256 loop
        T(j).Prio:=0;
      end loop;
      Open(Fichier, In_File, Nom_Fichier);
      Flux := Stream(Fichier);

      Put("Lecture des donnees: ");

      --Put(Integer'Input(Flux));
      --Put(", ");
      --Put(Integer(Octet'Input(Flux))); -- cast necessaire Octet -> Integer

      -- lecture tant qu'il reste des caracteres
      while not End_Of_File(Fichier) loop -- on lit le fichier
        C := Character'Input(Flux);
      --  Put(", "); Put(C);
        T(Character'Pos(C)).Prio:=T(Character'Pos(C)).Prio+1;
        T(Character'Pos(C)).Data:=C;


      end loop;



      Close(Fichier);
      Put_Line("fermeture du fichier");


      for j in 0..256 loop -- on crée la file_priorite à partir du tableau nous nous sommes rendus compte trop tard
        if T(j).Prio>0 then --que l'utilisation du type tableau dès le départ s'avairait plus malin dans ce cas
          huffman.A:=creer_arbre(T(j).Data,T(j).Prio);

          huffman.Nb_Total_Caracteres:=T(j).Prio;
          Insere(F,huffman,T(j).Prio);-- on insere que ceux dont la priorite est superieure à 0 cad ils sont présents
        end if;
      end loop;
      while(Get_Taille(F)>1) loop   -- on crée l'abre en supprimant sortants les deux arbres les plus prioritaires et en inserant l'arbre fusionné.
      Supprime(F,moins_prio1,prio1);
      Supprime(F,moins_prio2,prio2);
      Fusion_Arbre(moins_prio1,moins_prio2);
      Insere(F,moins_prio1,moins_prio1.Nb_Total_Caracteres);
    end loop;
    Supprime(F,moins_prio1,prio1);
    return moins_prio1;
  end Cree_Huffman;
  -- Stocke un arbre dans un flux ouvert en ecriture
  -- Le format de stockage est celui decrit dans le sujet
  -- Retourne le nb d'octets ecrits dans le flux (pour les stats)

  procedure Ecrit_Arbre(A:in Arbre;Flux : Ada.Streams.Stream_IO.Stream_Access) is    -- cette procédure recursive permet de réecrire l'arbre dans un programme.
begin
  if A.filsgauche/=NULL then
    Ecrit_Arbre(A.filsgauche,Flux);
  end if;
  if A.filsdroit/=NULL then
    Ecrit_Arbre(A.filsdroit,Flux);
  end if;


  if A.filsgauche=NULL and A.filsdroit=NULL then
    Character'Output(Flux,A.valeur);
    Integer'Output(Flux,A.occurence);

  end if ;
end Ecrit_Arbre;


function Ecrit_Huffman(H : in Arbre_Huffman;Flux : Ada.Streams.Stream_IO.Stream_Access)
return Positive is
begin

  Natural'Output(Flux,H.Nb_Total_Caracteres);   -- permet de savoir quand il on a atteint la fin de l'abre lors de l'ouverture du fichier compressé.
  Put("Ecriture des donnees: ");
  Ecrit_Arbre(H.A,Flux);
  return 1;
end Ecrit_Huffman;

--Lit un arbre stocke dans un flux ouvert en lecture
-- Le format de stockage est celui decrit dans le sujet
function Lit_Huffman(Flux : Ada.Streams.Stream_IO.Stream_Access)
return Arbre_Huffman is
  Nb_caractere:Natural;
  T : array(0..256) of cellule;     -- tableau dont le nombre de case correspont à la representation décimale des Characters
  i:Natural:=0;
  F:File_Prio:=Cree_File(256);    --file prioritaire pour la creation de l'arbre
  C:Character;
  Prio:Integer;
  huffman,moins_prio1,moins_prio2 : Arbre_Huffman;      --elements intermedaires pour la fusion des arbres
  prio1,prio2:Integer;                  -- elements facilitants l'utilisation des fonctions de file_priorite
begin
  for j in 0..256 loop
    T(j).Prio:=0;
  end loop;
  Nb_caractere:=Natural'Input(Flux);  --ce nombre permet de savoir quand on doit arreter de lire le fichier
  while(i<Nb_caractere) loop --boucle tant qu'on a pas atteint le nombre de caractere
    C:=Character'Input(Flux);
    T(Character'Pos(C)).Data:=C;
    Prio:=Integer'Input(Flux);
    T(Character'Pos(C)).Prio:=Prio;
    i:=i+Prio;
  end loop;
  for j in 0..256 loop -- on crée la file_priorite à partir du tableau nous nous sommes rendus compte trop tard
    if T(j).Prio>0 then --que l'utilisation du type tableau dès le départ s'avairait plus malin dans ce cas
      huffman.A:=creer_arbre(T(j).Data,T(j).Prio);

      huffman.Nb_Total_Caracteres:=T(j).Prio;
      Insere(F,huffman,T(j).Prio); -- on insere que ceux dont la priorite est superieure à 0 cad ils sont présents
    end if;
  end loop;

  while(Get_Taille(F)>1) loop     -- creation de l'arbre
    Supprime(F,moins_prio1,prio1);
    Supprime(F,moins_prio2,prio2);
    Fusion_Arbre(moins_prio1,moins_prio2); -- fusion des deux arbres les plus petits
    Insere(F,moins_prio1,moins_prio1.Nb_Total_Caracteres);

  end loop;
  Supprime(F,moins_prio1,prio1);
  return moins_prio1;
end Lit_Huffman;


procedure Genere_Dic_Arbre(A: in Arbre; D:in out Dico_Caracteres;C:in out Code_Binaire) is
  C1:Code_Binaire:=Cree_Code(C); -- fonction recursive pour le parcours de l'arbre
begin

  if A.filsdroit/=NULL then
    Ajoute_Apres(ZERO,C);
    Genere_Dic_Arbre(A.filsdroit,D,C);
  end if;
  if A.filsgauche/=NULL then

    Ajoute_Apres(UN,C1);
    Genere_Dic_Arbre(A.filsgauche,D,C1);
  end if;


  if A.filsgauche=NULL and A.filsdroit=NULL then    -- les données ne sont présentes que sur les feuilles

    Set_Code(A.valeur,C,D);
    Libere_Code(C1);
  end if ;
end Genere_Dic_Arbre;

-- Retourne un dictionnaire contenant les caracteres presents
-- dans l'arbre et leur code binaire (evite les parcours multiples)
-- de l'arbre
function Genere_Dictionnaire(H : in Arbre_Huffman) return Dico_Caracteres is
  D:Dico_Caracteres:=Cree_Dico;
  C: Code_Binaire:=Cree_Code;


begin
  Put("a");       -- on a juste a appeler la fonction recursive
  Genere_Dic_Arbre(H.A,D,C);
  return D;

end Genere_Dictionnaire;




------ Parcours de l'arbre (decodage)

-- Parcours a l'aide d'un iterateur sur un code, en partant du noeud A
--  * Si un caractere a ete trouve il est retourne dans Caractere et
--    Caractere_Trouve vaut True. Le code n'a eventuellement pas ete
--    totalement parcouru. A est une feuille.
--  * Si l'iteration est terminee (plus de bits a parcourir ds le code)
--    mais que le parcours s'est arrete avant une feuille, alors
--    Caractere_Trouve vaut False, Caractere est indetermine
--    et A est le dernier noeud atteint.
--procedure Get_Caractere(It_Code : in Iterateur_Code; A : in out Arbre;
--    Caractere_Trouve : out Boolean;
--  Caractere : out Character);


end Huffman;
