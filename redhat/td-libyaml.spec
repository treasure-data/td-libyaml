# $Id$
# Authority: dries
# Upstream: Kirill <xi$gamma,dn,ua>

Summary: Implementation of a YAML 1.1 parser and emitter
Name: td-libyaml
Version: 0.1.4
Release: 1%{?dist}
License: MIT/X Consortium
Group: Development/Libraries
URL: http://pyyaml.org/wiki/LibYAML

Packager: Dries Verachtert <dries@ulyssis.org>
Vendor: Dag Apt Repository, http://dag.wieers.com/apt/

Source: %{name}-%{version}.tar.gz
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root

%description
LibYAML is a C library implementation of a YAML 1.1 parser and emitter.
It includes a Python language binding.

# 2011/08/01 Kazuki Ohta <kazuki.ohta@gmail.com>
# prevent stripping the debug info.
%define debug_package %{nil}
%define __strip /bin/true

%prep

%setup -n yaml-%{version}

%build

%configure --prefix=%{_libdir}/fluent/libyaml --exec-prefix=%{_libdir}/fluent/libyaml --libdir=%{_libdir}/fluent/libyaml/lib --includedir=%{_libdir}/fluent/libyaml/include
%{__make} %{?_smp_mflags} AM_CFLAGS=""

%install
%{__rm} -rf %{buildroot}
%{__make} install DESTDIR=%{buildroot}

%post -p /sbin/ldconfig
%postun -p /sbin/ldconfig

%clean
%{__rm} -rf %{buildroot}

%files
%defattr(-, root, root, 0755)
%doc
%{_libdir}/fluent/libyaml/

%changelog
* Tue Dec 27 2011 Rilindo Foster (rilindo.foster@monzell.com - 0.1.4-1
- Updated to release 0.1.4, added path to pkgconfig

* Mon May 17 2010 Dag Wieers <dag@wieers.com> - 0.1.3-1
- Updated to release 0.1.3.

* Mon May 28 2007 Dries Verachtert <dries@ulyssis.org> - 0.0.1-1
- Initial package.
