{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  django-debug-toolbar,
  psycopg2,
  jinja2,
  beautifulsoup4,
  python,
  pytz,
}:

buildPythonPackage rec {
  pname = "django-cachalot";
  version = "2.7.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "noripyt";
    repo = "django-cachalot";
    tag = "v${version}";
    hash = "sha256-Fi5UvqH2bVb4v/GWDkEYIcBMBVos+35g4kcEnZTOQvw=";
  };

  patches = [
    # Disable tests for unsupported caching and database types which would
    # require additional running backends
    ./disable-unsupported-tests.patch
  ];

  propagatedBuildInputs = [ django ];

  checkInputs = [
    beautifulsoup4
    django-debug-toolbar
    psycopg2
    jinja2
    pytz
  ];

  pythonImportsCheck = [ "cachalot" ];

  # disable broken pinning test
  preCheck = ''
    substituteInPlace cachalot/tests/read.py \
      --replace-fail \
        "def test_explain(" \
        "def _test_explain("
  '';

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} runtests.py
    runHook postCheck
  '';

  meta = with lib; {
    description = "No effort, no worry, maximum performance";
    homepage = "https://github.com/noripyt/django-cachalot";
    changelog = "https://github.com/noripyt/django-cachalot/blob/${src.rev}/CHANGELOG.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
  };
}
