Name:		Remixed-terminix-schemes
Version:	1.0
Release:	1%{?dist}
Summary:	Remixed scheme for Terminix
Group:		User Interface/Desktops
License:	GPL-3
URL:		https://github.com/zeten30/Remixed
Vendor:		Milan Zink <zeten30@gmail.com>
Source0:	terminix-Remixed.json
Requires: 	terminix
BuildArch:	noarch

%description
Remixed scheme for Terminix

%prep
# %setup -q -n themes

%build
# Nothing to build

%install
#%{__install} -d -m755 %{buildroot}%{_datadir}/terminix/schemes/
%{__cp} -pr terminix-Remixed.json %{buildroot}%{_datadir}/terminix/schemes/

%files
%defattr(-,root,root)
%{_datadir}/terminix/schemes/terminix-Remixed.json

%changelog
* Thu Feb 2 2017 Milan Zink <zeten30@gmail.com> - 1.0.1
- Initial package for Fedora
