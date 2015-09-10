use Net::Kubernetes::Resource;

role Net::Kubernetes::Role::ResourceFactory {
    method create_resource_object(%object, $kind) {
    	$kind ||= %object<kind>;
    	my %create_args = %object;
    	%create_args<api_version> = %object<apiVersion>;
    	%create_args<username> = $.username;
    	%create_args<password> = $.password;
    	%create_args<url> = $.url;
    	%create_args<base_path> = %object<metadata><selfLink>;
        given $kind {
            when 'Pod' {
                return Net::Kubernetes::Resource::Pod.new(|%create_args);
            }
            default {
                return Net::Kubernetes::Resource.new(|%create_args);
            }
        }
    }
}