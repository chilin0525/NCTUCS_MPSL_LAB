#include<iostream>
#include<bits/stdc++.h>
using namespace std;
int main(){
    long long t=pow(2,31)-1;
    cout<<t<<'\n';

    long long  a[100]={0};
    a[0]=0;
    a[1]=1;

    int i;
    for(i=2;i<100;i++){
        a[i]=a[i-1]+a[i-2];
        if(a[i]<0)break;
    }
    cout<<a[46]<<endl;
    cout<<a[47]<<endl;
}
