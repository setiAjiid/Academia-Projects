#include <bits/stdc++.h>
using namespace std;

int main() {
    unordered_map<string, string> old_map, new_map;
    set<string> old_set, new_set;

    // Input struktur lama
    string parent, child;
    while (cin >> parent >> child) {
        if (parent == "0" && child == "0") break;
        old_map[child] = parent;
        old_set.insert(child);
    }

    // Input struktur baru
    while (cin >> parent >> child) {
        if (parent == "0" && child == "0") break;
        new_map[child] = parent;
        new_set.insert(child);
    }

    int updates = 0, insertions = 0, deletions = 0;

    // Cek update
    for (const auto& [child, parent_old] : old_map) {
        if (new_map.count(child)) {
            string parent_new = new_map[child];
            if (parent_new != parent_old) {
                updates++;
            }
        }
    }

    // Cek insertion
    for (const string& f : new_set) {
        if (!old_set.count(f)) insertions++;
    }

    // Cek deletion
    for (const string& f : old_set) {
        if (!new_set.count(f)) deletions++;
    }

    // Output sesuai format
    cout << updates << " update" << (updates != 1 ? "s" : "") << ", ";
    cout << "+" << insertions << " insertion" << (insertions != 1 ? "s" : "") << ", ";
    cout << "-" << deletions << " deletion" << (deletions != 1 ? "s" : "") << ".\n";

    return 0;
}
