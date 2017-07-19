#include "globals.h"

//void init() { 
//	for (int i = 0; i<V; ++i) p[i] = i; 
//}

int find(int x) { 
	return x == p[x] ? x : (p[x] = find(p[x])); 
}

void uni(int x, int y) {
	p[find(x)] = find(y); 
}

__device__ int finden(int x) {
	return x == cudaptrp[x] ? x : (cudaptrp[x] = finden(cudaptrp[x]));
}

__device__ void dieunio(int x,int y) {
	cudaptrp[finden(x)] = finden(y);
}

//struct suche
//{
//	__host__ __device__
//	int operator()(int &_x) {
//		return _x == cudap[_x] ? _x : (cudap[_x] = find(cudap[_x]));
//	}
//};
//
//struct dieuni
//{
//	__host__ __device__
//	void operator()(int x, int y) {
//		cudap[find(x)] = find(y);
//	}
//};
//
//struct funktion
//{
//	__host__ __device__
//	void operator()(bounder &_x) {
//		int a = suchen(_x.a);
//		int b = suchen(_x.b);
//		int c = _x.c;
//		if (a == b) return;
//		cross_edge += 1;
//		if (c < minweight[a] || c == minweight[a] && i < selectedbounders[a]) {
//			minweight[a] = c;
//			selectedbounders[a] = i;
//		}
//
//		if (c < minweight[b] || c == minweight[b] && i < selectedbounders[b]) {
//			minweight[b] = c;
//			selectedbounders[b] = i;
//		}
//	}
//};

__global__ void funktion(bounder *cedge) {
	int i = blockIdx.x*blockDim.x + blockIdx.x;
	int a = cedge[i].a;
	int b = cedge[i].b;
	int c = cedge[i].c;
	if (c < cudaptrmw[a] || c == cudaptrmw[a] && i < cudaptrsb[a]) {
		cudaptrmw[a] = c;
		cudaptrsb[a] = i;
	}
	if (c < cudaptrmw[a] || c == cudaptrmw[a] && i < cudaptrsb[a]) {
		cudaptrmw[a] = c;
		cudaptrsb[a] = i;
	}
}

void Boruvka()
{
	thrust::copy(first, first + 4, cudap.begin());
	bounder* cudaptredge;
	cudaptredge = thrust::raw_pointer_cast(cudaedge.data());
	cudaptrsb = thrust::raw_pointer_cast(cudaselectedbounders.data());
	cudaptrp = thrust::raw_pointer_cast(cudap.data());
	cudaptrmw = thrust::raw_pointer_cast(cudaminweight.data());
	//funktion <<<5, 1 >>> (bounder cudaptredge);
	while (true)
	{
		cross_edge = 0;
		thrust::fill(cudaminweight.begin(), cudaminweight.end(), 1e9);
		funktion << <5, 1 >> > (bounder cudaptredge);
		if (cross_edge == 0) break;
		for (int i = 0; i<V; ++i)
			if (minweight[i] != 1e9)
				uni(edge[selectedbounders[i]].a, edge[selectedbounders[i]].b);
		break;
	}
	vector<int> tmp(V);
	thrust::copy(selectedbounders.begin(), selectedbounders.end(), tmp.begin());
	set<int> finalroute(tmp.begin(), tmp.end());
	int allweight = 0;
	cout << "selected bounders:" << endl;
	for (auto i : finalroute) {
		cout << "vertex(a)=" << edge[i].a << "\tvertex(b)=" << edge[i].b << "\tbouder weight(c)=" << edge[i].c << endl;
		allweight += edge[i].c;
	}
	cout << "total weight:" << allweight << endl;
}

int main() {
	cudaedge.push_back({ 0,1,10 });
	cudaedge.push_back({ 0,2,6 });
	cudaedge.push_back({ 0,3,5 });
	cudaedge.push_back({ 2,3,4 });
	cudaedge.push_back({ 1,3,15 });
	edge.push_back({ 0,1,10 });
	edge.push_back({ 0,2,6 });
	edge.push_back({ 0,3,5 });
	edge.push_back({ 2,3,4 });
	edge.push_back({ 1,3,15 });
	Boruvka();
	system("pause");
	return 0;
}