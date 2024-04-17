#include <tcl.h>
#include <tclvfs.h>

#include <stdio.h>
#include <stdlib.h>

#define ZIPFS_VOLUME "//zipfs:/"
#define ZIPFS_APP_MOUNT ZIPFS_VOLUME "app"

int main(int argc, char *argv[])
{
    Tcl_FindExecutable(argv[0]);
    Tcl_Interp *interp = Tcl_CreateInterp();
    if (interp == NULL) {
        fprintf(stderr, "fail to create tcl interpreter\n");
        return EXIT_FAILURE;
    }

    int rv = TclZipfs_MountBuffer(interp, tclvfs_zip, tclvfs_zip_len, ZIPFS_APP_MOUNT, 0);
    if (rv != TCL_OK) {
        fprintf(stderr, "fail to mount tcl libraries to %s\n", ZIPFS_APP_MOUNT);
        Tcl_DeleteInterp(interp);
        return EXIT_FAILURE;
    }

    rv = Tcl_Init(interp);
    if (rv != TCL_OK) {
        fprintf(stderr, "fail to init tcl\n");
        Tcl_DeleteInterp(interp);
        return EXIT_FAILURE;
    }

    rv = Tcl_Eval(interp, "info library");
    const char *result = Tcl_GetStringResult(interp);
    if (rv != TCL_OK) {
        fprintf(stderr, "fail to evaluate file: %s\n", result);
        Tcl_DeleteInterp(interp);
        return EXIT_FAILURE;
    }

    printf("%s\n", result);
    Tcl_DeleteInterp(interp);
    return EXIT_SUCCESS;
}
