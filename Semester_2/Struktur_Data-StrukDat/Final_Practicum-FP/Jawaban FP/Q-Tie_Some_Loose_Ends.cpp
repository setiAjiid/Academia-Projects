// Keputih, Surabaya, Jawa Timur, Indonesia - 10/06/25 - 21.22

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


void dfs(string node, map<string, vector<string>> &v, map<string, bool> &vis){
    vis[node] = 1;
    for (auto adj: v[node]){
        if(!vis[adj]){
            dfs(adj, v, vis);
        }
    }
}

int main(){
    final_praktikum;
    int n, m;
    cin >> n >> m;
    map<string, vector<string>> v;
    set<string> st;
    for (int i = 0; i < m; i++){
        string x, y;
        cin >> x >> y;
        st.insert(x);
        st.insert(y);
        v[x].push_back(y);
        v[y].push_back(x);
    }

    map<string, bool> vis;
    int e;
    cin >> e;

    int cnt = 0;
    for (auto i: st){
        if (!vis[i]){
            cnt++;
            dfs(i, v, vis);
        }
    }

//    cout << st.size() << el;
    cnt += (st.size() < n ? n - st.size() : 0) + 2;

    if (e > cnt - 2){
        cout << "You tied the loose ends and reached her.";
    } else if (e == cnt - 2) {
        cout << "You tied the loose ends but couldn't reach her.";
    } else cout << "You didn't tie the loose ends. She remains out of reach.";
}
