// Keputih, Surabaya, Jawa Timur, Indonesia - 11/06/25 - 13.37
//                                          - 12/06/25 - 15.13 (Lanjut sebelumnya prioritasin quiz kalkulus 2)

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
    string a, s;
    getline(cin, a);
    stringstream strstr(a);
    stack<ll> st;
    while (getline(strstr, s, ' ')){
        if (s == "C"){
            st.pop();
        } else if (s == "+"){
            ll tmp = st.top();
            st.pop();
            ll sum = st.top() + tmp;
            st.push(tmp);
            st.push(sum);
        } else if (s == "D"){
            st.push(st.top() * 2);
        } else {
            int x = stoi(s);
            st.push(x);
        }
    }

    ll ans = 0;
    while (!st.empty()){
        ans += st.top();
        st.pop();
    }
    cout << ans;

}
