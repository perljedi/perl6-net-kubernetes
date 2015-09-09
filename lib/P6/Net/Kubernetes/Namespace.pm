use P6::Net::Kubernetes::Role::APIAccess;

class P6::Net::Kubernetes::Namespace does P6::Net::Kubernetes::Role::APIAccess {
    has Str $.namespace;
}
