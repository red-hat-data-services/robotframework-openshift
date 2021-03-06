
from pathlib import Path
from robot.libdoc import libdoc


def keywords_docs():
    """Generates the library keyword documentation.
    Documentation is generated by using the Libdoc tool.
    """
    out = Path("docs/OpenShiftLibrary.html")
    libdoc(str(Path("OpenShiftLibrary")), str(out))


if __name__ == "__main__":
    keywords_docs()
