prinprint_board(Size) :-
    print_row_separator(Size),
    print_rows(Size, 1),
    print_row_separator(Size).

print_rows(Size, Row) :-
    (Row > Size -> true ; print_row(Size, Row, 1), NextRow is Row + 1, print_rows(Size, NextRow)).

print_row(Size, Row, Col) :-
    (Col > Size -> write('|'), nl ; print_cell(Row, Col), NextCol is Col + 1, print_row(Size, Row, NextCol)).

print_cell(Row, Col) :-
    (write('|'),
     fixed_cell(Row, Col, Num) -> write('[ '), write(Num), write(' ]') ;
   (solve_cell(Row, Col, Color) -> write('['), write(Color), write(']') ;
     write(' '))).


print_row_separator(Size) :-
    write_list('-', 4*Size), nl.

write_list(_, 0).
write_list(Item, N) :-
    write(Item),
    N1 is N - 1,
    write_list(Item, N1).

%size(5).




fixed_cell(1,5,1).
solve_cell(2,3,blue).
fixed_cell(3,5,2).
fixed_cell(5,4,1).

solve_cell(1,1,blue).
solve_cell(1,2,blue).
solve_cell(1,3,blue).
solve_cell(1,4,blue).


solve_cell(2,1,blue).
solve_cell(2,2,green).
solve_cell(2,4,blue).
solve_cell(2,5,blue).


solve_cell(3,1,blue).
solve_cell(3,2,green).
solve_cell(3,3,blue).
solve_cell(3,4,green).


solve_cell(4,1,blue).
solve_cell(4,2,green).
solve_cell(4,3,green).
solve_cell(4,4,blue).
solve_cell(4,5,blue).


solve_cell(5,1,blue).
solve_cell(5,2,blue).
solve_cell(5,3,blue).
solve_cell(5,5,blue).



% تابع لإيجاد المجاورات للخلية ذات اللون نفسه
get_neighbors(Row, Col, Color, Neighbors) :-
    findall([X, Y],
            (neighbor_position(Row, Col, X, Y),
             solve_cell(X, Y, Color)),
            Neighbors).
            
                  % تابع للتحقق من لون الخلية الأصلية
get_cell_color(Row, Col, green) :-
    fixed_cell(Row, Col, _), !.
get_cell_color(Row, Col, Color) :-
    solve_cell(Row, Col, Color).

% تابع لإيجاد الخلايا المجاورة التي تشكل جزيرة من نفس اللون
get_island(Row, Col, Color, Island) :-
    explore(Row, Col, Color, [], Island).

% تابع للمساعدة في استكشاف الخلايا المجاورة
explore(Row, Col, Color, Visited, Island) :-
    (member([Row, Col], Visited) ->
        Island = Visited
    ;
        findall([X, Y],
                (neighbor_position(Row, Col, X, Y),
                 get_cell_color(X, Y, Color)),
                Neighbors),
        explore_neighbors(Neighbors, Color, [[Row, Col] | Visited], Island)
    ).



    ).



% تابع لاستكشاف جميع الخلايا المجاورة
explore_neighbors([], _, Island, Island).
explore_neighbors([[Row, Col] | Rest], Color, Visited, Island) :-
    explore(Row, Col, Color, Visited, NewVisited),
    explore_neighbors(Rest, Color, NewVisited, Island).

% تابع للتحقق من المواقع المجاورة الممكنة
neighbor_position(Row, Col, X, Y) :-
    (X is Row + 1, Y is Col);
    (X is Row - 1, Y is Col);
    (X is Row, Y is Col + 1);
    (X is Row, Y is Col - 1).

% تابع رئيسي لإيجاد الخلايا من نفس اللون المتجاورة أو جميع الخلايا الزرقاء
get_sea_or_island(Row, Col, Color, Result) :-
    (get_cell_color(Row, Col, ActualColor),
     ActualColor = Color ->
        (Color == blue ->
            findall([X, Y], solve_cell(X, Y, blue), Result)
        ;
            get_island(Row, Col, Color, Result));  false).
            
            