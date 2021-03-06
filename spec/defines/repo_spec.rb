require 'spec_helper'

describe 'aptly::repo' do
  let(:title) { 'example' }

  let(:facts){{
    :lsbdistid => 'ubuntu',
    :osfamily  => 'Debian',
  }}

  describe 'param defaults' do
    it {
        should contain_exec('aptly_repo_create-example').with({
          :command  => /aptly -config \/etc\/aptly.conf repo create *example$/,
          :unless   => /aptly -config \/etc\/aptly.conf repo show example >\/dev\/null$/,
          :user     => 'root',
          :require  => [ 'Package[aptly]','File[/etc/aptly.conf]' ],
      })
    }
  end

  describe 'user defined component' do
    let(:params){{
      :component => 'third-party',
    }}

    it {
        should contain_exec('aptly_repo_create-example').with({
          :command  => /aptly -config \/etc\/aptly.conf repo create *-component="third-party" *example$/,
          :unless   => /aptly -config \/etc\/aptly.conf repo show example >\/dev\/null$/,
          :user     => 'root',
          :require  => [ 'Package[aptly]','File[/etc/aptly.conf]' ],
      })
    }

    context 'custom user' do
      let(:pre_condition)  { <<-EOS
        class { 'aptly':
          user => 'custom_user',
        }
        EOS
      }

      let(:params){{
        :component => 'third-party',
      }}

      it {
          should contain_exec('aptly_repo_create-example').with({
            :command  => /aptly -config \/etc\/aptly.conf repo create *-component="third-party" *example$/,
            :unless   => /aptly -config \/etc\/aptly.conf repo show example >\/dev\/null$/,
            :user     => 'custom_user',
            :require  => [ 'Package[aptly]','File[/etc/aptly.conf]' ],
        })
      }
    end
  end

  describe 'user defined architectures' do
    context 'passing valid values' do
      let(:params){{
        :architectures => ['i386','amd64'],
      }}

      it {
        should contain_exec('aptly_repo_create-example').with({
          :command  => /aptly -config \/etc\/aptly.conf repo create *-architectures="i386,amd64" *example$/,
          :unless   => /aptly -config \/etc\/aptly.conf repo show example >\/dev\/null$/,
          :user     => 'root',
          :require  => [ 'Package[aptly]','File[/etc/aptly.conf]' ],
        })
      }
    end

    context 'passing invalid values' do
      let(:params){{
        :architectures => 'amd64'
      }}

      it {
        should raise_error(Puppet::Error, /is not an Array/)
      }
    end
  end

  describe 'user defined comment' do
    let(:params){{
      :comment => 'example comment',
    }}

    it {
      should contain_exec('aptly_repo_create-example').with({
        :command  => /aptly -config \/etc\/aptly.conf repo create *-comment="example comment" *example$/,
        :unless   => /aptly -config \/etc\/aptly.conf repo show example >\/dev\/null$/,
        :user     => 'root',
        :require  => [ 'Package[aptly]','File[/etc/aptly.conf]' ],
      })
    }
  end

  describe 'user defined distribution' do
    let(:params){{
      :distribution => 'example_distribution',
    }}

    it {
      should contain_exec('aptly_repo_create-example').with({
        :command  => /aptly -config \/etc\/aptly.conf repo create *-distribution="example_distribution" *example$/,
        :unless   => /aptly -config \/etc\/aptly.conf repo show example >\/dev\/null$/,
        :user     => 'root',
        :require  => [ 'Package[aptly]','File[/etc/aptly.conf]' ],
      })
    }
  end

end
