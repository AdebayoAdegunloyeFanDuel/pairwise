require 'rubygems'
require 'spec'

require File.dirname(__FILE__) + '/pairwise'

describe "pairwise" do

  it "should be invalid when running with no input" do
    lambda{ Pairwise.generate([]) }.should raise_error(Pairwise::InvalidInput)
    lambda{ Pairwise.generate([{:A => []}]) }.should raise_error(Pairwise::InvalidInput)
  end

  it "should be invalid when running with only 1 input" do
    lambda{ Pairwise.generate([{:A => [:A1, :A2]}])}.should raise_error(Pairwise::InvalidInput)
  end

  it "should generate all pairs for two parameters" do
    data = [{:A => [:A1, :A2]},
            {:B => [:B1, :B2]}]

    Pairwise.generate(data).should == [[:A1, :B1], [:A1, :B2], [:A2, :B1], [:A2, :B2]]
  end


  describe 'ipo horizontal growth' do
    before(:each) do
      @test_pairs = [[:A1, :B1], [:A1, :B2], [:A2, :B1], [:A2, :B2]]

      @data = [[:A1, :A2],[:B1, :B2],[:C1 , :C2 , :C3 ]]
    end
    
    it "should return pairs extended with C's inputs" do
      test_set, _ = Pairwise.send(:ipo_h, @test_pairs, @data[2], @data[0..1])

      test_set.should == [[:A1, :B1, :C1],
                          [:A1, :B2, :C2],
                          [:A2, :B1, :C3],
                          [:A2, :B2, :C1]]
    end

    it "should return all the uncovered pairs" do
      _, pi = Pairwise.send(:ipo_h, @test_pairs, @data[2], @data[0..1])

      # We are getting the uncovered pairs in reverse
      #pi.should == [[:A2, :C2],[:A1, :C3],[:B1, :C2],[:B2, :C3]]
      # Cheat and check we get the list in reverse
      pi.should == [[:C2, :A2], [:C2, :B1], [:C3, :A1], [:C3, :B2]]
    end
  end


  context "with dataset with unequal input sizes" do
    it "should generate pairs for three paramters" do
      data = [{:A => [:A1, :A2]},
              {:B => [:B1, :B2]},
              {:C => [:C1 , :C2 , :C3 ]}]

      Pairwise.generate(data).should == [[:A1, :B1, :C1],
                                         [:A1, :B2, :C2],
                                         [:A2, :B1, :C3],
                                         [:A2, :B2, :C1],
                                         [:A2, :B1, :C2],
                                         [:A1, :B2, :C3]]
    end
  end

  context "with data set with same number of inputs" do
    it "should generate pairs for three paramters" do
      data = [{:A => [:A1, :A2]},
              {:B => [:B1, :B2]},
              {:C => [:C1 , :C2]}]

      Pairwise.generate(data).should == [[:A1, :B1, :C1],
                                         [:A1, :B2, :C2],
                                         [:A2, :B1, :C2],
                                         [:A2, :B2, :C1]]
    end
  end
  
end