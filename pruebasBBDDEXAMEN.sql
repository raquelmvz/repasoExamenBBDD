/* un select de los emails que esten mal es decir tengan mas de un "@ o un . seguido de 2 o 3 caracteres */
select *
from clientes
where not email rlike '@[a-z]*\\.(com|net|es|eu)$';

