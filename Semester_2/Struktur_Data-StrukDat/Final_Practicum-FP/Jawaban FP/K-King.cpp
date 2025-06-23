// Keputih, Surabaya, Jawa Timur, Indonesia - 13/06/25 - 07.25
//                                          - 15/06/25 - 00.10

#include <bits/stdc++.h>
using namespace std;

#define ll long long
#define ull unsigned long long
#define el '\n'
#define final_praktikum ios::sync_with_stdio(0), cin.tie(0)

//#include <ext/pb_ds/assoc_container.hpp>
//#include <ext/pb_ds/tree_policy.hpp>
//using namespace __gnu_pbds;
//typedef tree<pair<int, int>, null_type, less<pair<int, int>>, rb_tree_tag, tree_order_statistics_node_update> ordered_set;

string find_up(string node, map<string, string> &parent){
    if (node == parent[node]){
        return node;
    }
    return parent[node] = find_up(parent[node], parent);
}

void unionByRank(string u, string v, map<string, ll> &_rank, map<string, string> &parent){
    string up_u = find_up(u, parent);
    string up_v = find_up(v, parent);
    if (up_u == up_v) return;
    if (_rank[up_u] > _rank[up_v]){
        parent[up_v] = up_u;
    } else if (_rank[up_u] < _rank[up_v]){
        parent[up_u] = up_v;
    } else {
        parent[up_v] = up_u;
        _rank[up_u]++;
    }
}

int main(){
    final_praktikum;
    int n;
    cin >> n;
    map<string, string> parent;
    map<string, ll> _rank;
    while (n--){
        string s, u, v;
        cin >> s >> u >> v;
        if (s == "RECRUIT" || s == "ALLY"){
            if (parent.find(u) == parent.end()){
                parent[u] = u;
            }
            if (parent.find(v) == parent.end()){
                parent[v] = v;
            }
            unionByRank(u, v, _rank, parent);
        } else if (s == "CHECK"){
            if (parent.find(u) == parent.end() || parent.find(v) == parent.end() || find_up(u, parent) != find_up(v, parent)){
                cout << "NO" << el;
            } else cout << "YES" << el;
        }
    }
}
