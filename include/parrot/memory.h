/* memory.h
 *  Copyright: (When this is determined...it will go here)
 *  CVS Info
 *     $Id$
 *  Overview:
 *     This is the api header for the memory subsystem
 *  Data Structure and Algorithms:
 *  History:
 *  Notes:
 *  References:
 */

#if !defined(PARROT_MEMORY_H_GUARD)
#define PARROT_MEMORY_H_GUARD

void *mem_allocate_aligned(size_t);

void *mem_sys_allocate(size_t);

void *mem_realloc(struct Parrot_Interp *, void *, size_t, size_t);

#define gc_used mem_realloc

void *mem_sys_realloc(void *, size_t);

void mem_sys_free(void *);

void mem_setup_allocator(struct Parrot_Interp *);

#define mem_allocate_new_stash() NULL
#define mem_allocate_new_stack() NULL
#define mem_sys_memcopy memcpy
#define mem_sys_memmove memmove
#define Parrot_mark_used_memory(a, b, c) mem_realloc(a, b, c, c)

#endif

/*
 * Local variables:
 * c-indentation-style: bsd
 * c-basic-offset: 4
 * indent-tabs-mode: nil 
 * End:
 *
 * vim: expandtab shiftwidth=4:
*/
