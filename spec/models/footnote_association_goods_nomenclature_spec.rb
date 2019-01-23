require "rails_helper"

describe FootnoteAssociationGoodsNomenclature do
  describe "validations" do
    describe "conformance rules" do
      describe "ME71: Footnotes with a footnote type for which the application type = 'CN footnotes' cannot be associated with TARIC codes (codes with pos. 9-10 different from 00)" do
        it "shoud run validation succesfully" do
          footnote_association_goods_nomenclature = described_class.new
          footnote_association_goods_nomenclature.goods_nomenclature_item_id = "3826009011"
          footnote_association_goods_nomenclature.footnote_type = "NC"

          expect(footnote_association_goods_nomenclature).to be_conformant
        end

        it "shoud not run validation succesfully" do
          footnote_association_goods_nomenclature = described_class.new
          footnote_association_goods_nomenclature.goods_nomenclature_item_id = "3826009000"
          footnote_association_goods_nomenclature.footnote_type = "NC"

          expect(footnote_association_goods_nomenclature).not_to be_conformant
          expect(footnote_association_goods_nomenclature.conformance_errors).to have_key(:ME71)

          footnote_association_goods_nomenclature.goods_nomenclature_item_id = "3826009011"
          footnote_association_goods_nomenclature.footnote_type = "TN"

          expect(footnote_association_goods_nomenclature).not_to be_conformant
          expect(footnote_association_goods_nomenclature.conformance_errors).to have_key(:ME71)
        end
      end
    end
  end
end
