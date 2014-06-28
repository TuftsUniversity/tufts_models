require 'spec_helper'

describe TuftsImage do
  describe "to_class_uri" do
    subject {TuftsImage}
    it "has sets the class_uri" do
      expect(subject.to_class_uri).to eq 'info:fedora/cm:Image.4DS'
    end
  end

  describe "external_datastreams" do
    it "should have the correct ones" do
      subject.external_datastreams.keys.should include('Advanced.jpg', 'Basic.jpg', 'Archival.tif', 'Thumbnail.png')
    end
  end


  it "should have an original_file_datastream" do
    TuftsImage.original_file_datastreams.should == ["Archival.tif"]
  end

  describe "an image with a pid" do
    describe "that is provided by the user" do
      before do
        subject.inner_object.pid = 'tufts:MS054.003.DO.02108'
      end
      it "should give a remote url" do
        subject.remote_url_for('Archival.tif', 'tif').should == 'http://bucket01.lib.tufts.edu/data01/tufts/central/dca/MS054/archival_tif/MS054.003.DO.02108.archival.tif'
      end
      it "should give a local_path" do
        subject.local_path_for('Archival.tif', 'tif').should == File.expand_path("../../fixtures/local_object_store/data01/tufts/central/dca/MS054/archival_tif/MS054.003.DO.02108.archival.tif", __FILE__)
      end
    end
    describe "that is autogenerated" do
      before do
        subject.inner_object.pid = 'tufts:1234'
      end
      it "should give a remote url" do
        subject.remote_url_for('Archival.tif', 'tif').should == 'http://bucket01.lib.tufts.edu/data01/tufts/sas/archival_tif/1234.archival.tif'
      end
      it "should give a local_path" do
        subject.local_path_for('Archival.tif', 'tif').should == File.expand_path("../../fixtures/local_object_store/data01/tufts/sas/archival_tif/1234.archival.tif", __FILE__)
      end
    end
  end

  describe "create_derivatives" do
    before do
      subject.inner_object.pid = 'tufts:MISS.ISS.IPPI'
    end
    describe "basic" do
      before { subject.create_basic }
      it "should create Basic.jpg" do
        File.exists?(subject.local_path_for('Basic.jpg', 'jpg')).should be_truthy
        subject.datastreams["Basic.jpg"].dsLocation.should == "http://bucket01.lib.tufts.edu/data01/tufts/central/dca/MISS/basic_jpg/MISS.ISS.IPPI.basic.jpg"
        subject.datastreams["Basic.jpg"].mimeType.should == "image/jpeg"
      end
    end

    describe "advanced" do
      before { subject.create_advanced }
      it "should create Advanced.jpg" do
        File.exists?(subject.local_path_for('Advanced.jpg', 'jpg')).should be_truthy
        subject.datastreams["Advanced.jpg"].dsLocation.should == "http://bucket01.lib.tufts.edu/data01/tufts/central/dca/MISS/advanced_jpg/MISS.ISS.IPPI.advanced.jpg"
        subject.datastreams["Advanced.jpg"].mimeType.should == "image/jpeg"
      end
    end

    describe "thumbnail" do
      before { subject.create_thumbnail }
      it "should create Thumbnail.png" do
        File.exists?(subject.local_path_for('Thumbnail.png', 'png')).should be_truthy
        subject.datastreams["Thumbnail.png"].dsLocation.should == "http://bucket01.lib.tufts.edu/data01/tufts/central/dca/MISS/thumbnail_png/MISS.ISS.IPPI.thumbnail.png"
        subject.datastreams["Thumbnail.png"].mimeType.should == "image/png"
      end
    end

  end



end
