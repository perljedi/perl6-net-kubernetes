use Net::Kubernetes::Role::APIAccess;

class Net::Kubernetes::Namespace does Net::Kubernetes::Role::APIAccess {
    has Str $.namespace;
}
