import std.stdio;
import std.random;

extern (C) void InitWindow(int, int, const char*);
extern (C) void SetTargetFPS(int);
extern (C) bool WindowShouldClose();

struct Color {
	char r;
	char g;
	char b;
	char a;
}

extern (C) void ClearBackground(Color);

extern (C) void BeginDrawing();
extern (C) void DrawRectangle(int, int, int, int, Color);
extern (C) void EndDrawing();
extern (C) void CloseWindow();

int[100][100] board;
int[100][100] nextBoard;

const Color BLACK = Color(0, 0, 0, 255);
const Color WHITE = Color(255, 255, 255, 255);

bool valid(int x, int y) {
	return x >= 0 && x < 100 && y >= 0 && y < 100;
}

int countNeighbors(int x, int y) {
	int cnt = 0;
	if(valid(x-1,y) && board[x-1][y] == 1) cnt++;
	if(valid(x+1,y) && board[x+1][y] == 1) cnt++;
	if(valid(x,y+1) && board[x][y+1] == 1) cnt++;
	if(valid(x,y-1) && board[x][y-1] == 1) cnt++;
	if(valid(x-1,y+1) && board[x-1][y+1] == 1) cnt++;
	if(valid(x-1,y-1) && board[x-1][y-1] == 1) cnt++;
	if(valid(x+1,y+1) && board[x+1][y+1] == 1) cnt++;
	if(valid(x+1,y-1) && board[x+1][y-1] == 1) cnt++;
	return cnt;
}

void main() {

	for(auto i = 0; i < 100; i++) {
		for(auto j = 0; j < 100; j++) {
			int n = uniform!"[]"(0, 1);
			board[i][j] = n;
		}
	}

	InitWindow(400, 400, "GOL in D");

	SetTargetFPS(30);

	while(!WindowShouldClose()){
		for(auto i = 0; i < 100; i++) {
			for(auto j = 0; j < 100; j++) {
				int cnt = countNeighbors(i, j);
				bool isAlive = board[i][j] == 1;
				if(isAlive && cnt < 2) nextBoard[i][j] = 0;
				if(isAlive && cnt > 3) nextBoard[i][j] = 0;
				if(isAlive && cnt >=2 && cnt <= 3) nextBoard[i][j] = 1;
				if(!isAlive && cnt == 3) nextBoard[i][j] = 1;
			}
		}

		board = nextBoard;

		ClearBackground(WHITE);
		BeginDrawing();

		for(auto i = 0; i < 100; i++) {
			for(auto j = 0; j < 100; j++) {
				int n = board[i][j];

				Color c = n == 1 ? BLACK : WHITE;
				DrawRectangle(i * 4, j * 4, 4, 4, c);
			}
		}


		EndDrawing();
	}

	CloseWindow();
}

