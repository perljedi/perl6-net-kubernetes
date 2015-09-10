use Net::Kubernetes::Role::APIAccess;
use Net::Kubernetes::Resource;
use JSON::Fast;
use Net::Kubernetes::Role::ResourceFactory;

class Net::Kubernetes::Namespace does Net::Kubernetes::Role::APIAccess does Net::Kubernetes::Role::ResourceFactory {
    has Str $.namespace;

    method get_pod ($name) {
        say $.path() ~ '/pods/' ~ $name;
        my $res = $.create_request(:method('GET'), :url($.path() ~ '/pods/' ~ $name)).run();
        say $res;
        if ($res.success) {
            my %pod = from-json($res.content).pairs;
            return $.create_resource_object(%pod);
            #return Net::Kubernetes::Resource.new(:url($.url), :base_path(%pod<metadata><selfLink>), :metadata(%pod<metadata>), :api_version($.api_version), :username($.username), :password($.password), :token($.token))
        }
    }
    method list_pods () {
        my $res = $.create_request(:method('GET'), :url($.path() ~ '/pods')).run();
        say $res;
        if ($res.success) {
            my %pods = from-json($res.content).pairs;
            my @pods = ();
            for @(%pods<items>) -> $item {
                my %pod = %($item);
                %pod<api_version> = %pods<apiVersion>;
                @pods.push: $.create_resource_object(%pod, 'Pod');
            }
            return @pods;
        }
    }
}
