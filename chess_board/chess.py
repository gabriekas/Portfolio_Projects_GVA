#Define main function to create logic for the game
def main():

    print("\nCurrent chess game setting is based on a combination of pawns and rooks only\n")
    print("\nAim: to answer whether white chess figure can take any black figures\n")

    #List of possible colours of the figures
    colour = ["white", "black"]

    #1. Initialize and store the empty board state 
    board_state = get_new_board_state()

    #2. Get player inputs
    player_inputs = ask_for_user_input(colour, board_state)

    #3. For each player input update the current board state - where the move was made 
    for player_input in player_inputs:
        board_state = update_board_state(board_state, player_input)

    #4. After player input has been completed, store board list with full set of input coordinates and print board
    board_list = board_state
    print_board(board_state)

    #5. Check which black pieces if any can be taken by white piece and print the answer
    pieces_that_can_be_taken = check_for_taken_pieces(board_list, player_inputs)
    if pieces_that_can_be_taken:
        print("Pieces that can be taken:\n", pieces_that_can_be_taken)
    else:
        print("No pieces can be taken this time\n")


#Define function for board initialization
def get_new_board_state():
    return[
        [" ", " ", " ", " ", " ", " ", " ", " "],
        [" ", " ", " ", " ", " ", " ", " ", " "],
        [" ", " ", " ", " ", " ", " ", " ", " "],
        [" ", " ", " ", " ", " ", " ", " ", " "],
        [" ", " ", " ", " ", " ", " ", " ", " "],
        [" ", " ", " ", " ", " ", " ", " ", " "],
        [" ", " ", " ", " ", " ", " ", " ", " "],
        [" ", " ", " ", " ", " ", " ", " ", " "]
    ]

#Define a function which asks for user input and prints board state after each input
def ask_for_user_input(colour, board_state):
    n = 0 #current number of figures inputed before the start of the loop
    taken_coordinates = set()
    inputs = [] #collection of all inputs before return
    #Input for a white piece and its validation:
    print(f"\nChoose a {colour[0]} figure from pawn and rook and enter its coordinates on the board (e.g. pawn b3)\n")
    print_board(board_state)

    while True:
        player_input = input().strip().lower()
        figure, _, coordinates = player_input.partition(" ")
        if entry_validity(figure, coordinates, taken_coordinates):
            n += 1
            inputs.append((figure, coordinates, "W"))
            board_state = update_board_state(board_state, (figure, coordinates, "W"))
            print_board(board_state)
            print(f"{colour[0].title()} figure has been added successfully\n" )
            break
    #Input of black pieces and their validation
    print(f"Choose a {colour[1]} figure from pawn and rook and enter its coordinates on the board (e.g. rook e5). You will be able to add up to {17-n} figures\n")
    while  1 <= n < 18:
        player_input = input().strip().lower()
        figure, _, coordinates = player_input.partition(" ")
        if player_input == "done":
            if n < 2:
                print(f"{colour[1].title()} figure was not added, please add more figures\n")
                continue
            else:
                print("\nAll pieces have been added successfully\n")
                break
        if entry_validity(figure, coordinates, taken_coordinates):
            n += 1
            inputs.append((figure, coordinates, "B"))
            board_state = update_board_state(board_state, (figure, coordinates, "B"))
            print_board(board_state)
            print (f"{colour[1].title()} figure has been added successfully, you can add {17-n} more figures or enter 'done'\n")
    return inputs

#Validate user input
def entry_validity(figure, coordinates, taken_coordinates):
    figures = ["pawn", "rook"] #list of figures
    if figure in figures\
        and len(coordinates) == 2\
            and coordinates[0] in "abcdefgh"\
                and coordinates[1] in "12345678"\
                    and coordinates not in taken_coordinates:
        taken_coordinates.add(coordinates)
        return True
    elif coordinates in taken_coordinates:
        print("\nA figure was already assigned to this position. Please choose different coordinates\n")
    else:
        print("\nIncorrect input, please try again\n")
    return False


def update_board_state(board_state, player_input):

    figure, coordinates, type = player_input
    if figure == "pawn" and type == "W":
        figure_symbol = "♙"
    elif figure == "pawn" and type == "B":
        figure_symbol = "♟"
    elif figure == "rook" and type == "W":
        figure_symbol = "♖"
    elif figure == "rook" and type == "B":
        figure_symbol = "♜"
    else:
        None
    x_coordinate, y_coordinate = coord_to_index(coordinates)
    board_state[x_coordinate][y_coordinate] = figure_symbol

    return board_state



def check_for_taken_pieces(board_list, player_inputs):
    #player_inputs[0] - first tuple in the list (white piece)
    #player_inputs[0][1] - coordinates of white piece from the tuple (figure, coordinates, type)
    white_coords = coord_to_index(player_inputs[0][1])
    captures = []
    if player_inputs[0][0] == "pawn":

        if board_list[white_coords[0]+1][white_coords[1]+1] != " " and board_list[white_coords[0]+1][white_coords[1]+1] != "WP":
            captures.append(index_to_coord((white_coords[0]+1),(white_coords[1]+1)))
        if board_list[white_coords[0]+1][white_coords[1]-1] != " " and board_list[white_coords[0]+1][white_coords[1]+1] != "WP":
            captures.append(index_to_coord((white_coords[0]+1),(white_coords[1]-1)))

   #If figure is rook
    elif player_inputs[0][0] == "rook":
        #Check rows above the white rook
        for row in range(white_coords[0], -1, -1):
            if board_list[row][white_coords[1]] != " "\
                    and board_list[row][white_coords[1]] != "WR":
                captures.append(index_to_coord(row,white_coords[1]))
                break 

        #Check rows below the white rook
        for row in range(white_coords[0], 8):
            if board_list[row][white_coords[1]] != " "\
                    and board_list[row][white_coords[1]] != "WR":
                captures.append(index_to_coord(row,white_coords[1]))
                break

        #Check columns from the left of the white rook
        for col in range(white_coords[1], -1, -1):
            if board_list[white_coords[0]][col] != " "\
                    and board_list[white_coords[0]][col] != "WR":
                captures.append(index_to_coord(white_coords[0],col))
                break

        #Check columns from the right of the white rook
        for col in range(white_coords[1], 8):
            if board_list[white_coords[0]][col] != " "\
                and board_list[white_coords[0]][col] != "WR":
                captures.append(index_to_coord(white_coords[0],col))
                break 

    return captures

def coord_to_index(coordinates):
    #adjustment to zero based indexing - converting string into integer and subtracting 1 to get 0
    x = int(coordinates[1]) - 1  # Convert the number in the coordinate to an index
    #ASCII value of "a" is 97 so ord("a") - ord("a") -> 97 - 97 = 0, for "b" it's 98 - 97 = 1, etc, to get zero based indexing
    y = ord(coordinates[0]) - ord('a')  # Convert the letter in the coordinate to an index
    return (x, y)

def index_to_coord(x, y):
    columns = ["a", "b", "c", "d", "e", "f", "g", "h"]
    rows = ["1","2","3","4","5","6","7","8"]
    return columns[y] + rows[x]

def print_board(board_state):
    row_number = 0
    print ("       a  ", "  b  ", "  c  ","  d  ", "  e  ", "  f  ", "  g  ", "  h  ")
    #board_state contains 8 lists for each row
    #Loop through each list, printing the row each time
    for row in board_state:
        #For rows 0 to 7 print top line and column separator
        if row_number <= 7:
            print("    |‾‾‾‾‾|‾‾‾‾‾|‾‾‾‾‾|‾‾‾‾‾|‾‾‾‾‾|‾‾‾‾‾|‾‾‾‾‾|‾‾‾‾‾|")
        print(str(row_number + 1).rjust(2), " ", end="")
        row_number += 1
        print("|     |     |     |     |     |     |     |     |")
        #center(2) centers a string to be 2 characters long
        print("    | ", row[0].center(2), "  |  ", row[1].center(2), " |  ", row[2].center(2), " |  ", row[3].center(2), " |  ", row[4].center(2), " |  ", row[5].center(2), " |  ", row[6].center(2), " |  ", row[7].center(2), " | ", sep="")
    
    #Final bottom line
    print("     _____ _____ _____ _____ _____ _____ _____ _____\n")
    row_number += 1




main()

