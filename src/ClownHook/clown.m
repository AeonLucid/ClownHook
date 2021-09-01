#import <stdio.h>
#import <signal.h>
#import <unistd.h>
#import <dlfcn.h>
#import <sys/mman.h>
#import <sys/ucontext.h>
#import <mach/mach.h>
#import <mach-o/loader.h>
#import <Foundation/Foundation.h>
#import <unicorn/unicorn.h>

static void page_mapper(int signo, siginfo_t *info, void *uapVoid) {
    printf("[+] page_mapper %p\n", info->si_addr);
    abort();
}

void clown_init() {
    uc_engine *uc;
    uc_err err;

    err = uc_open(UC_ARCH_ARM64, UC_MODE_ARM, &uc);
    if (err) {
        printf("Failed on uc_open() with error returned: %u (%s)\n",
                err, uc_strerror(err));
        return;
    }

    printf("[+] clown_init\n");

    struct sigaction act;
    memset(&act, 0, sizeof(act));
    act.sa_sigaction = page_mapper;
    act.sa_flags = SA_SIGINFO;

    if (sigaction(SIGSEGV, &act, NULL) < 0) {
        printf("sigaction\n");
    }

    if (sigaction(SIGBUS, &act, NULL) < 0) {
        printf("sigaction\n");
    }
}

void clown_hook(void *function, void *newFunction, void **originalFunction) {
    printf("[+] clown_hook\n");

    // Find page containing the function.
    vm_address_t page = trunc_page((vm_address_t) function);

    // Fuck up the page.
    kern_return_t kt = vm_allocate(mach_task_self(), &page, PAGE_SIZE, VM_FLAGS_FIXED|VM_FLAGS_OVERWRITE);

    if (kt != KERN_SUCCESS) {
        NSLog(@"Failed reserving sufficient space");
        return;
    }

    vm_protect(mach_task_self(), page, PAGE_SIZE, true, VM_PROT_NONE);
}