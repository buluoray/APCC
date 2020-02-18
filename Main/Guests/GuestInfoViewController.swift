//
//  GuestInfoViewController.swift
//  APCC
//
//  Created by Yusheng Xu on 2/16/20.
//  Copyright © 2020 Kulanui. All rights reserved.
//

import UIKit
import SafariServices

class GusetInfoViewController: UIViewController {
    
    private var business: Business?
    private lazy var guestInfoView: GuestInfoView = {
        let guestInfoView = GuestInfoView(frame: view.frame)
        
        return guestInfoView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
        setupNav()
        setupView()
    }
    

    
    func setupView(){
        view.addSubview(guestInfoView)
        guestInfoView.businessNameLabel.text = business?.businessName
        guestInfoView.businessDescriptionLabel.text = business?.businessDescription
        if let link = business?.promoLink{
            if let url = URL(string: link){
                let attributedString = NSMutableAttributedString(string: "Visit Website")
                let attributes = [
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light),
                    NSAttributedString.Key.foregroundColor: UIColor.themeColor,
                    NSAttributedString.Key.underlineColor: UIColor.clear,
                    NSAttributedString.Key.attachment:url ] as [NSAttributedString.Key : Any]
                attributedString.addAttributes(attributes, range: NSRange(location: 0, length: 13))
                guestInfoView.businessPromoLabel.attributedText = attributedString
                guestInfoView.businessPromoLabel.delegate = self
            }
        }
        guestInfoView.layoutIfNeeded()
    }
    
    func setupNav(){
        overrideUserInterfaceStyle = .light
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .themeColor
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Guests", style: .plain, target: nil, action: nil)
        navigationItem.title = "Guest Detail"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func setupModel(data: Business){
        self.business = data
    }
}

extension GusetInfoViewController: LinkLabelDelegate{
    func openURl(url: URL) {
        let safari = SFSafariViewController(url: url)
        safari.preferredBarTintColor = #colorLiteral(red: 0.5490196078, green: 0, blue: 0.05490196078, alpha: 1)
        safari.preferredControlTintColor = .white
        safari.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        present(safari, animated: true, completion: nil)
    }
}

protocol LinkLabelDelegate: class {
    func openURl(url: URL)
}

public class LinkLabel: UILabel {
    private var storage: NSTextStorage?
    private let textContainer = NSTextContainer()
    private let layoutManager = NSLayoutManager()
    private var selectedBackgroundView = UIView()
    weak var delegate: LinkLabelDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        textContainer.lineFragmentPadding = 0
        layoutManager.addTextContainer(textContainer)
        textContainer.layoutManager = layoutManager
        isUserInteractionEnabled = true
        selectedBackgroundView.isHidden = true
        selectedBackgroundView.backgroundColor = UIColor(white: 0, alpha: 0.3333)
        selectedBackgroundView.layer.cornerRadius = 4
        addSubview(selectedBackgroundView)
    }

    public required convenience init(coder: NSCoder) {
        self.init(frame: .zero)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        textContainer.size = frame.size
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        setLink(for: touches)
    }

    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        setLink(for: touches)
    }

    private func setLink(for touches: Set<UITouch>) {
        if let pt = touches.first?.location(in: self), let (characterRange, _) = link(at: pt) {
            let glyphRange = layoutManager.glyphRange(forCharacterRange: characterRange, actualCharacterRange: nil)
            selectedBackgroundView.frame = layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer).insetBy(dx: -3, dy: -3)
            selectedBackgroundView.isHidden = false
        } else {
            selectedBackgroundView.isHidden = true
        }
    }

    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        selectedBackgroundView.isHidden = true
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        selectedBackgroundView.isHidden = true

        if let pt = touches.first?.location(in: self), let (_, url) = link(at: pt) {
            //UIApplication.shared.open(url)
            delegate?.openURl(url: url)
        }
    }

    private func link(at point: CGPoint) -> (NSRange, URL)? {
        let touchedGlyph = layoutManager.glyphIndex(for: point, in: textContainer)
        let touchedChar = layoutManager.characterIndexForGlyph(at: touchedGlyph)
        var range = NSRange()
        let attrs = attributedText!.attributes(at: touchedChar, effectiveRange: &range)
        if let urlstr = attrs[.attachment] as? URL {
            return (range, urlstr)
        } else {
            return nil
        }
    }

    public override var attributedText: NSAttributedString? {
        didSet {
            textContainer.maximumNumberOfLines = numberOfLines
            textContainer.lineBreakMode = lineBreakMode
            if let txt = attributedText {
                storage = NSTextStorage(attributedString: txt)
                storage!.addLayoutManager(layoutManager)
                layoutManager.textStorage = storage
                textContainer.size = frame.size
            }
        }
    }
}
