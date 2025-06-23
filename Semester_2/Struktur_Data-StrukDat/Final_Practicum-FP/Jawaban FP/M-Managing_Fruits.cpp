// Keputih, Surabaya, Jawa Timur, Indonesia - 10/06/25 - 19.49

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
    ll n;
    cin >> n;
    map<string, ll> mp;
    map<string, bool> cek;
    for (ll i = 0; i < n; i++){
        string s, buah;
        cin >> s >> buah;
        ll cnt;
        cin >> cnt;
        if (s == "ADD"){
            mp[buah] += cnt;
            cek[buah] = 1;
        } else {
            if (cek[buah] != 1){
                cout << "item not found" << el;
            } else if (mp[buah] >= cnt){
                mp[buah] -= cnt;
                cout << "SUCCESS" << el;
            } else {
                cout << "not enough stock" << el;
            }
        }
    }

}
