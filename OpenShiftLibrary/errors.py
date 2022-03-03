class OpenShiftLibraryException(Exception):
    ROBOT_CONTINUE_ON_FAILURE = True


class ResourceNotFound(OpenShiftLibraryException):
    pass


class ResourceOperationFailed(OpenShiftLibraryException):
    pass
