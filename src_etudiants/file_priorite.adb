with Ada.Integer_Text_IO, Ada.Text_IO;
use Ada.Integer_Text_IO, Ada.Text_IO;
with Ada.Unchecked_Deallocation;
package body File_Priorite is
type File_Interne is record
  Capacite: Positive;
  Taille: Integer;
  Data:Donnee;
  Prio:Priorite;
  suiv:File_Prio;
end record;

procedure Free is new Ada.Unchecked_Deallocation (File_Interne,File_Prio);





function Cree_File(Capacite: Positive) return File_Prio is
  F:File_Prio:=new File_Interne;
begin
  F.Capacite:=Capacite;
  F.Taille:=0;
  return F;
end Cree_File;


  -- Libere une file de priorite.
  -- garantit: en sortie toute la memoire a ete libere, et F = null.
procedure Libere_File(F : in out File_Prio) is
  p:File_Prio:=F;
begin
  while(F/=NULL) loop
    p:=F;
    F:=F.suiv;
    Free(p);
  end loop;
end Libere_File;
  -- retourne True si la file est vide, False sinon
function Est_Vide(F: in File_Prio) return Boolean is
begin
  if F=NULL or else F.Taille=0 then return True;
else return False;
end if;
end Est_Vide;

  -- retourne True si la file est pleine, False sinon
function Est_Pleine(F: in File_Prio) return Boolean is
begin
  if F.Taille=F.Capacite then return True;
else return False;
end if;
end Est_Pleine;

  -- si not Est_Pleine(F)
  --   insere la donnee D de priorite P dans la file F
  -- sinon
  --   leve l'exception File_Pleine

function Get_Taille(F:File_Prio) return Integer is
begin
  return F.Taille;
end Get_Taille;

procedure Insere(F : in out File_Prio; D : in Donnee; P : in Priorite) is
  add:File_Prio:=new File_Interne;
  courant: File_Prio:=F;
  i : Integer:=0;
begin
  if not Est_Pleine(F) then

    add.capacite:=F.Capacite;
    add.Taille:=F.Taille+1;  -- on enregistre la taille de la liste si jamais l'élément se retrouve ne tête de liste
    add.Data:=D;
    add.Prio:=P;
    if Est_Vide(F) then -- si la file est vide, il n'est pas nécessaire de faire une allocation seulement de rentrée la donnée dans le premier élément
      F.all:=add.all;
      Free(add);
      --F.Taille:=F.Taille+1;
    else

      if add.Prio<F.Prio then -- lors de l'ajout la liste est triée pour faciliter la suppression d'éléments

        add.suiv:=F;
        F:=add;
      else
          F.Taille:=F.Taille+1; -- si l'élément n'est pas en tête de liste on met à jour la taille
      while (courant.suiv/=NULL and i=0) loop
          if add.Prio<courant.suiv.Prio then
            i:=1;
          else
              courant:=courant.suiv;
          end if ;
        end loop;
        add.suiv:=courant.suiv;
          courant.suiv:=add;
      end if;
    end if;
  else
    raise File_Prio_Pleine;
  end if;
end Insere;







  -- si not Est_Vide(F)
  --   supprime la donnee la plus prioritaire de F.
  --   sortie: D est la donnee, P sa priorite
  -- sinon
  --   leve l'exception File_Vide
procedure Supprime(F: in File_Prio; D: out Donnee; P: out Priorite) is
  act:File_Prio;
  begin
  if not Est_Vide(F) then
    D:=F.Data;
    P:=F.Prio;
    if F.taille>1 then   -- si la taille est égale à 1 et retourner le premier élément il est juste nécessaire de mettre la taille à 0, la liste sera considéré vide
      F.Data:=F.suiv.Data;
      F.Prio:=F.suiv.Prio;
      act:=F.suiv;
      F.suiv:=F.suiv.suiv;
      Free(act);
    end if;
    F.Taille:=F.Taille-1;
  else
    raise File_Prio_Vide;
  end if;
end Supprime;



  -- si not Est_Vide(F)
  --   retourne la donnee la plus prioritaire de F (sans la
  --   sortir de la file)
  --   sortie: D est la donnee, P sa priorite
  -- sinon
  --   leve l'exception File_Vide
procedure Prochain(F: in File_Prio; D: out Donnee; P: out Priorite) is
begin
  if not Est_Vide(F) then
    D:=F.Data;
    P:=F.Prio;
  else
    raise File_Prio_Vide;
  end if;
end Prochain;

end File_Priorite;
