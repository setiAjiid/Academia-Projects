// Keputih, Surabaya, Jawa Timur, Indonesia - 10/06/25 - 20.26
//                                          - 13/06/25 - 01.21
//                                          - 13/06/25 - 07.11

#include <bits/stdc++.h>
using namespace std;

#define ll long long
#define ull unsigned long long
#define el '\n'
#define final_praktikum ios::sync_with_stdio(0), cin.tie(0)

#include <ext/pb_ds/assoc_container.hpp>
#include <ext/pb_ds/tree_policy.hpp>
using namespace __gnu_pbds;
typedef tree<pair<int, int>, null_type, less<pair<int, int>>, rb_tree_tag, tree_order_statistics_node_update> ordered_set;


int main(){
    final_praktikum;
    int n;
    cin >> n;
    vector<int> w(n);
    vector<pair<int, int>> v(n);
    for (int i = 0; i < n; i++){
        int x;
        cin >> x;
        v[i].first = x;
        v[i].second = i + 1;
    }

    vector<ll> pref(n + 1, 0);
    vector<ll> suff(n + 2, 0);

    pref[0] = 0;
    for (int i = 1; i <= n; i++){
        cin >> w[i - 1];
        pref[i] = w[i - 1] + pref[i - 1];
    }

    suff[n] = w[n - 1];
    for (int j = n - 1; j >= 1; j--){
        suff[j] = w[j - 1] + suff[j + 1];
    }

    sort(v.begin(), v.end());
    ordered_set os;
    os.insert({0, 0});
    os.insert({n + 1, 0});

    ll maks = 0;
    for (int i = 1; i <= n; i++){
        int h = v[i - 1].first;
        int idx = v[i - 1].second;

        os.insert({idx, h});
        auto cur = os.find({idx, h});
        auto l = prev(cur, 1);
        auto r = next(cur, 1);

        ll left = pref[cur->first] - pref[l->first];
        ll right = suff[cur->first] - suff[r->first];
        ll wi = w[cur->first - 1];
        maks = max(maks, h*(left + right - wi));
    }
    cout << maks;
}
