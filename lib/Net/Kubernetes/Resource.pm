use Net::Kubernetes::Role::APIAccess;

class Net::Kubernetes::Resource does Net::Kubernetes::Role::APIAccess {
    has Str $.kind;
    has %.metadata is rw;

    method delete() {
        my $res = $.create_request(:method("DELETE"), :url($.path)).run();
        return $res.success;
    }
    #
    # method as_hash() {
    #     # for self.^attributes -> $attr {
    #     #     say $attr;
    #     # }
    # }
}

role Net::Kubernetes::Resource::Role::State {
    has %.status
}

role Net::Kubernetes::Resource::Role::Spec {
    has %.spec;
}

class Net::Kubernetes::Resource::Pod is Net::Kubernetes::Resource does Net::Kubernetes::Resource::Role::State does Net::Kubernetes::Resource::Role::Spec {
    method logs() {
        return "some logs";
    }
}
