use Net::Kubernetes::Role::APIAccess;

class Net::Kubernetes::Resource
    does Net::Kubernetes::Role::APIAccess {
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

class Net::Kubernetes::Resource::Event
    is Net::Kubernetes::Resource {
    has Str $.reason;
    has Str $.message;
    has Str $.firstTimeStamp;
    has Str $.lastTimeStamp;
    has Int $.count;
    has %.source;
    has %.involvedObject;
}

class Net::Kubernetes::Resource::Pod
    is Net::Kubernetes::Resource
    does Net::Kubernetes::Resource::Role::State
    does Net::Kubernetes::Resource::Role::Spec
    does Net::Kubernetes::Role::APIAccess {

    method logs(%options?) {
        my $req = $.create_request(:method('GET'), :url($.path ~ '/log'));
        $req.add-field(|%options);
        my $res = $req.run;
        if $res.success {
            return $res.content;
        }
    }
}

class Net::Kubernetes::Resource::ReplicationController
    is Net::Kubernetes::Resource
    does Net::Kubernetes::Resource::Role::State
    does Net::Kubernetes::Resource::Role::Spec {
    method scale(){

    }
}

class Net::Kubernetes::Resource::Service
    is Net::Kubernetes::Resource
    does Net::Kubernetes::Resource::Role::State
    does Net::Kubernetes::Resource::Role::Spec {
}

class Net::Kubernetes::Resource::Secret
    is Net::Kubernetes::Resource
    {

    has Str $.type;
    has %.data;

    method render (%args) {

    }
}
