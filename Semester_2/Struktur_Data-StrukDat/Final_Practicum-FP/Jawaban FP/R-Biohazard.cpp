// Keputih, Surabaya, Jawa Timur, Indonesia - 10/06/25 - 19.28

#include <bits/stdc++.h>
using namespace std;

#define ll long long
#define ull unsigned long long
#define el '\n'
#define final_praktikum ios::sync_with_stdio(0), cin.tie(0)

//#include <ext/pb_ds/assoc_container.hpp>
//#include <ext/pb_ds/tree_policy.hpp>
//using namespace __gnu_pbds;
//typedef tree<int, null_type, less<int>, rb_tree_tag, tree_order_statistics_node_update> ordered_set;


int bfs (int x, int y, int posRow[], int posCol[], vector<string> &v, vector<vector<bool>> &vis){
    vis[x][y] = 1;
    int cnt = 1;
    queue<pair<int, int>> q;
    q.push({x, y});
    while (!q.empty()){
        int cur_x = q.front().first;
        int cur_y = q.front().second;
        q.pop();
        for (int i = 0; i < 4; i++){
            int nx = cur_x + posRow[i];
            int ny = cur_y + posCol[i];
            if (nx >= 0 && nx < (int)v.size() && ny >= 0 && ny < (int)v[0].size() && v[nx][ny] != '#' && !vis[nx][ny]){
                vis[nx][ny] = 1;
                q.push({nx, ny});
                cnt++;
            }
        }
    }
    return cnt;
}

int main(){
    final_praktikum;
    int n, m;
    cin >> n >> m;
    vector<string> v(n);
    for (int i = 0; i < n; i++){
        cin >> v[i];
    }

    int even = 0, cnt = 0, maks = 0;
    int posRow[] = {-1, 0, 1 , 0};
    int posCol[] = {0, 1, 0, -1};

    vector<vector<bool>> vis(n, vector<bool> (m, 0));
    for (int i = 0; i < n; i++){
        for (int j = 0; j < m; j++){
            if (v[i][j] == '+' && !vis[i][j]){
                int val = bfs(i, j, posRow, posCol, v, vis);
                if (!(val&1)){
                    even++;
                }
                maks = max(maks, val);
                cnt++;
            }
        }
    }

    cout << cnt << " " << maks << " " << even;
}
