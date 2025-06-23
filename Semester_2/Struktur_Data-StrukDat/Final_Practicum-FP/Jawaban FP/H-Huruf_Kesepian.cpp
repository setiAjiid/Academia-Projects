// Keputih, Surabaya, Jawa Timur, Indonesia - 10/06/25 - 20.13

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


int main(){
    final_praktikum;
    string s;
    cin >> s;
    map<char, int> mp;
    for (int i = 0; i < (int)s.size(); i++){
        mp[s[i]]++;
    }
    for (int i = 0; i < (int)s.size(); i++){
        if (mp[s[i]] == 1){
            cout << i;
            return 0;
        }
    }
    cout << -1;
}
