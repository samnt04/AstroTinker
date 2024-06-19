#include <stdint.h>
volatile uint32_t* const mem = (uint32_t*) 0x02000000;
#define start       mem[0] // 0x0
#define end         mem[1] // 0x4
#define node_point  mem[2] // 0x8
#define cpu_done    mem[3] 
#define p_visited   (&mem[4])
#define p_lparent   (&mem[5])
#define p_ldist     (&mem[6])
#define p_parent    (&mem[7])
#define p_dist      (&mem[11])
#define p_graph     (&mem[15])

// generic bit field getter
const static inline uint32_t get_bitfield(volatile uint32_t *p, uint32_t i) {
    return (p[0] >> i) & 1;
}

// generic bit field setter
const static inline void set_bitfield(volatile uint32_t *p, uint32_t i, uint32_t v) {
    p[0] = (p[0] & ((1 << i) ^ 0xFFFFFFFF)) | (v << i);
}

// generic half byte getter
const static inline uint32_t get_halfbyte(volatile uint32_t* p,uint32_t i) {
    return (p[i/8] >> 4*(i%8)) & 0xf;
}

// generic half byte setter
const static inline void set_halfbyte(volatile uint32_t* p, uint32_t i, uint32_t v) {
    p[i/8] = (p[i/8] & ((0xf << 4*(i%8)) ^ 0xFFFFFFFF)) | (v << 4*(i%8));
}

// msbs_lsb getter
const static inline uint32_t get_msbs_lsb(volatile uint32_t* p0, volatile uint32_t* p1,uint32_t i) {
    return (get_halfbyte(p0, i) << 1) | get_bitfield(p1, i);
}
// msbs_lsb setter
const static inline void set_msbs_lsb(volatile uint32_t* p0,volatile uint32_t * p1,uint32_t i,uint32_t nv) {
    set_halfbyte(p0, i, (nv >> 1));
    set_bitfield(p1, i, (nv & 1));
}

// helper functions
/*=====================================================================================================*/
const static inline uint32_t visited(uint32_t i) {
    // return (p_visited[0] >> i) & 1;
    return get_bitfield(p_visited, i);
}

const static inline void set_visited(uint32_t i, uint32_t nv) {
    // p_visited[0] = (p_visited[0] & (~(1 << i))) | (nv << i);
    set_bitfield(p_visited, i, nv);
}

/*=====================================================================================================*/
const static inline uint32_t parent(uint32_t i) {
    return get_msbs_lsb(p_parent, p_lparent, i);
}
const static inline void set_parent(uint32_t i, uint32_t nv) {
    set_msbs_lsb(p_parent, p_lparent, i, nv);
}
/*=====================================================================================================*/
const static inline uint32_t dist(uint32_t i) {
    return get_msbs_lsb(p_dist, p_ldist, i);
}
const static inline void set_dist(uint32_t i, uint32_t nv) {
    set_msbs_lsb(p_dist, p_ldist, i, nv);
}
/*=====================================================================================================*/
const static inline uint32_t graph(uint32_t i, uint32_t j) {
    return (p_graph[i] >> (8*j)) & 0xFF;
}
/*=====================================================================================================*/
#define N 30

int main() {
    /*INIT_GRAPH*/
	p_graph[0] = 0x1f1f1f01; p_graph[1] = 0x1f00021d; p_graph[2] = 0x1f080301; p_graph[3] = 0x1f1c0402; p_graph[4] = 0x1f060503; p_graph[5] = 0x1f1f1f04; p_graph[6] = 0x1f1f0704; p_graph[7] = 0x1f1f0806; p_graph[8] = 0x7090c02; p_graph[9] = 0x1f0b0a08; p_graph[10] = 0x1f1f1f09; p_graph[11] = 0x1f1f1f09; p_graph[12] = 0x1f130d08; p_graph[13] = 0x1f1f0e0c; p_graph[14] = 0x1f100d0f; p_graph[15] = 0x1f1f1f0e; p_graph[16] = 0x1f12110e; p_graph[17] = 0x1f1f1f10; p_graph[18] = 0x1f1f1310; p_graph[19] = 0x1f140c12; p_graph[20] = 0x18131d15; p_graph[21] = 0x1f171614; p_graph[22] = 0x1f1f1f15; p_graph[23] = 0x1f1f1f15; p_graph[24] = 0x1f1f1914; p_graph[25] = 0x1f1f1a18; p_graph[26] = 0x1f1c191b; p_graph[27] = 0x1f1f1f1a; p_graph[28] = 0x1f031d1a; p_graph[29] = 0x1f141c01; 
	//parent also needs to be initialized cos X behaves weird
    *p_visited = 0; *p_ldist = 0; *p_lparent = 0;
    p_parent[0] = 0; p_parent[1] = 0; p_parent[2] = 0; p_parent[3] = 0;
    p_dist[0] = 0; p_dist[1] = 0; p_dist[2] = 0; p_dist[3] = 0;
	for (uint32_t i = 0; i < N; ++i) {set_dist(i, 31); set_visited(i, 0); set_parent(i, 0);}   
    set_dist(end, 0); set_parent(end, 31);
    uint32_t min_dist; uint32_t min_index;
    for (uint32_t i = 0; i < (N - 1); ++i) {
        // finding start node for next iteration
        min_dist = 31;
        for (uint32_t j = 0; j < N; ++j) {
            uint32_t d = dist(j);
            if (!visited(j) && d < min_dist){
                min_dist = d; min_index = j;
            }
        }
        set_visited(min_index, 1);
        uint32_t d_min = dist(min_index) + 1;
        uint32_t node = p_graph[min_index] & 0xff;
        if (node != 31) {
            if (!visited(node) && d_min < dist(node)) {
                set_dist(node, d_min); set_parent(node, min_index);
            }
        }
        node = (p_graph[min_index] >> 8) & 0xff;
        if (node != 31) {
            if (!visited(node) && d_min < dist(node)) {
                set_dist(node, d_min); set_parent(node, min_index);
            }
        }
        node = (p_graph[min_index] >> 16) & 0xff;
        if (node != 31) {
            if (!visited(node) && d_min < dist(node)) {
                set_dist(node, d_min); set_parent(node, min_index);
            }
        }
        node = (p_graph[min_index] >> 24) & 0xff;
        if (node != 31) {
            if (!visited(node) && d_min < dist(node)) {
                set_dist(node, d_min); set_parent(node, min_index);
            }
        }
    }

    node_point = start;
    uint32_t curr = start;
    while (curr != end) {
        curr = parent(curr);
        node_point = curr;
    }
    cpu_done = 1; 
    return 0;
}