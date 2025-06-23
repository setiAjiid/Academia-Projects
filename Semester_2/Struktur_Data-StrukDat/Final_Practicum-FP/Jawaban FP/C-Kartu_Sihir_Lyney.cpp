// Keputih, Surabaya, Jawa Timur, Indonesia - 13/06/25 - 00.52

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
    int n;
    cin >> n;
    vector<int> v(n);
    for (int i = 0; i < n; i++){
        cin >> v[i];
    }

    ll maksL = v[0], maksR = v[n - 1], ans = 0, l = 0, r = n - 1;
    while (l <= r){
        if (maksL <= maksR){
            if (v[l] < maksL){
                ans += (maksL - v[l]);
            } else maksL = v[l];
            l++;
        } else {
            if (v[r] < maksR){
                ans += (maksR - v[r]);
            } else maksR = v[r];
            r--;
        }
//        cout << l << " " << r << " " << ans << " " << maksL << " " << maksR << " " << el;
    }
    cout << ans;
}
